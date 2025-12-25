import 'package:tremor_app/ml/bin_loader.dart';
import 'package:tremor_app/ml/preprocessing.dart';
import 'package:tremor_app/ml/scaler.dart';
import 'package:tremor_app/ml/tflite_model.dart';
import 'package:tremor_app/ml/tremor_inference.dart';

class TremorService {
  static final TremorService _instance = TremorService._internal();

  factory TremorService() {
    return _instance;
  }

  TremorService._internal();

  bool _initialized = false;

  TremorModel model = TremorModel();
  Scaler scaler = Scaler();
  BinLoader loader = BinLoader();

  late Preprocessor preprocessor;
  late TremorInference inference;

  Future<void> init() async {
    if (_initialized) return;

    print("!!!TREMORSERVICE_INIT!!!");

    await model.load();
    await scaler.load();

    preprocessor = Preprocessor(scaler);
    inference = TremorInference(model.interpreter);

    _initialized = true;
  }

  Future<double> runFromBin(String path) async {
    if (!_initialized) {
      throw Exception("TremorService not initialized. Call init() first.");
    }

    final raw = await loader.load(path);
    final input = preprocessor.process(raw);
    return inference.run(input);
  }
}
