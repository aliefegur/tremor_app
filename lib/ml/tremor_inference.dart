import 'dart:math';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class TremorInference {
  final Interpreter interpreter;

  TremorInference(this.interpreter);

  double run(Float32List input) {
    assert(input.length == 250 * 6);

    final output = List.filled(3, 0.0).reshape([1, 3]);

    interpreter.run(
      input.reshape([1, 250, 6]),
      output,
    );

    return (output[0] as List<double>).reduce(max);
  }
}
