import 'dart:typed_data';
import 'package:tremor_app/ml/scaler.dart';

class Preprocessor {
  final Scaler scaler;

  Preprocessor(this.scaler);

  Float32List process(List<double> raw) {
    if (raw.length % 6 != 0) {
      throw Exception('Raw input length (${raw.length}) is not divisible by 6');
    }

    final timesteps = raw.length ~/ 6;
    final buffer = Float32List(timesteps * 6);

    int offset = 0;

    for (int i = 0; i < raw.length; i += 6) {
      final featureVector = raw.sublist(i, i + 6);

      // same logic as before
      final normalized = scaler.transform(featureVector);

      for (int j = 0; j < 6; j++) {
        buffer[offset++] = normalized[j];
      }
    }

    return buffer;
  }
}
