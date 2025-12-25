import 'package:tflite_flutter/tflite_flutter.dart';

class TremorModel {
  static Interpreter? _interpreter;

  Interpreter get interpreter => _interpreter!;

  Future<void> load() async {
    if (_interpreter != null) return;

    final interpreter = await Interpreter.fromAsset(
      'assets/mobile_ai_package/model/parkinson_cnn_model.tflite',
    );

    interpreter.resizeInputTensor(0, [1, 250, 6]);
    interpreter.allocateTensors();

    _interpreter = interpreter;
  }
}
