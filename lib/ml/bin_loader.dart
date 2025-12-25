import 'package:flutter/services.dart';

class BinLoader {
  Future<List<double>> load(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asFloat32List().toList();
  }
}
