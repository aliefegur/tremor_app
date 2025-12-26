import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tremor_app/services/tremor_service.dart';

class TimedSample {
  final double x, y, z;
  final DateTime timestamp;

  TimedSample(this.x, this.y, this.z, this.timestamp);
}

List<TimedSample> resample(
  List<TimedSample> buffer,
  DateTime start,
  DateTime end, {
  int targetSamples = 250,
}) {
  List<TimedSample> resampled = [];

  if (buffer.isEmpty) return resampled;

  // Toplam süre
  final totalMs = end.difference(start).inMilliseconds;
  if (totalMs <= 0) return resampled;

  // Her sample için interval
  final intervalMs = totalMs / targetSamples;

  for (int i = 0; i < targetSamples; i++) {
    final t = start.add(Duration(milliseconds: (i * intervalMs).round()));

    // t'ye en yakın iki sample'ı bul
    TimedSample? before;
    TimedSample? after;

    // buffer sıralı olduğunu varsayıyoruz
    for (int j = 0; j < buffer.length - 1; j++) {
      if (!buffer[j].timestamp.isAfter(t) &&
          buffer[j + 1].timestamp.isAfter(t)) {
        before = buffer[j];
        after = buffer[j + 1];
        break;
      }
    }

    if (before == null || after == null) {
      // Eğer t buffer dışında → son sample veya ilk sample kullan
      if (t.isBefore(buffer.first.timestamp)) {
        resampled.add(buffer.first);
      } else {
        resampled.add(buffer.last);
      }
    } else {
      // lineer interpolation
      double factor =
          t.difference(before.timestamp).inMilliseconds /
          after.timestamp.difference(before.timestamp).inMilliseconds;
      double x = before.x + factor * (after.x - before.x);
      double y = before.y + factor * (after.y - before.y);
      double z = before.z + factor * (after.z - before.z);
      resampled.add(TimedSample(x, y, z, t));
    }
  }

  return resampled;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Real-Time Tremor Score Test", (tester) async {
    // Tremor service
    final service = TremorService();

    await service.init();

    // Sensor data
    List<TimedSample> accBuffer = [];
    List<TimedSample> gyroBuffer = [];

    // Sample begin & end
    DateTime accBufferFirst = DateTime.now();
    DateTime gyroBufferFirst = DateTime.now();

    // Accelerometer data stream
    final accSub =
        userAccelerometerEventStream(
          samplingPeriod: SensorInterval.normalInterval,
        ).listen((UserAccelerometerEvent event) {
          accBuffer.add(TimedSample(event.x, event.y, event.z, DateTime.now()));
        }, onError: (e) => print(e));

    // Gyroscope data stream
    final gyroSub =
        gyroscopeEventStream(
          samplingPeriod: SensorInterval.normalInterval,
        ).listen((GyroscopeEvent event) {
          gyroBuffer.add(
            TimedSample(event.x, event.y, event.z, DateTime.now()),
          );
        }, onError: (e) => print(e));

    // Get tremor score every 2.5 seconds
    Timer.periodic(Duration(milliseconds: 2500), (timer) {
      DateTime now = DateTime.now();
      List<TimedSample> resampledAcc = resample(
        accBuffer,
        accBufferFirst,
        now,
      );
      List<TimedSample> resampledGyro = resample(
        gyroBuffer,
        gyroBufferFirst,
        now,
      );

      final raw = List<double>.generate(250 * 6, (i) {
        if (i % 6 == 0) {
          return resampledAcc[i ~/ 6].x;
        } else if (i % 6 == 1) {
          return resampledAcc[i ~/ 6].y;
        } else if (i % 6 == 2) {
          return resampledAcc[i ~/ 6].z;
        } else if (i % 6 == 3) {
          return resampledGyro[i ~/ 6].x;
        } else if (i % 6 == 4) {
          return resampledGyro[i ~/ 6].y;
        } else {
          return resampledGyro[i ~/ 6].z;
        }
      });

      final processed = service.preprocessor.process(raw);
      final score = service.inference.run(processed);

      print("Tremor score: $score");

      // Clear buffers
      accBuffer.clear();
      gyroBuffer.clear();
      accBufferFirst = DateTime.now();
      gyroBufferFirst = DateTime.now();
    });

    await Future.delayed(Duration(hours: 1));

    await accSub.cancel();
    await gyroSub.cancel();
  });
}
