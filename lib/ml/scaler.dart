import 'dart:convert';
import 'package:flutter/services.dart';

class Scaler {
  late List<double> mean;
  late List<double> scale;

  Future<void> load() async {
    final jsonStr = await rootBundle.loadString('assets/mobile_ai_package/preprocessing/scaler_params.json');

    final Map<String, dynamic> json = jsonDecode(jsonStr);

    final meanList = json['mean'];
    final scaleList = json['scale'];

    if (meanList == null || scaleList == null) {
      throw Exception(
          'Scaler params missing. Found keys: ${json.keys}'
      );
    }

    mean = (meanList as List).map((e) => (e as num).toDouble()).toList();
    scale = (scaleList as List).map((e) => (e as num).toDouble()).toList();
  }

  List<double> transform(List<double> input) {
    if (input.length != mean.length) {
      throw Exception(
          'Input length (${input.length}) does not match scaler length (${mean.length})'
      );
    }

    return List.generate(input.length, (i) {
      return (input[i] - mean[i]) / scale[i];
    });
  }
}
