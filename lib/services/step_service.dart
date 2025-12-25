import 'dart:async';
import 'package:pedometer/pedometer.dart';

class StepService {
  Stream<StepCount> get stream => Pedometer.stepCountStream;
}
