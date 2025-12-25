import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Gyroscope & Accelometer Test", (tester) async {
    final accSub =
        userAccelerometerEventStream(
          samplingPeriod: SensorInterval.normalInterval,
        ).listen((UserAccelerometerEvent event) {
          print(event);
        }, onError: (e) => print(e.toString()));

    final gyroSub =
        gyroscopeEventStream(
          samplingPeriod: SensorInterval.normalInterval,
        ).listen((GyroscopeEvent event) {
          print(event);
        }, onError: (e) => print(e.toString()));

    await Future.delayed(Duration(seconds: 30));

    await accSub.cancel();
    await gyroSub.cancel();
  });
}
