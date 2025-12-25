import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/step_service.dart';

class DailyStepState extends ChangeNotifier {
  static const int dailyGoal = 6000;

  final StepService _service = StepService();
  StreamSubscription? _sub;

  int dailySteps = 0;
  bool goalCompleted = false;

  int? _dayBaseSteps;
  String? _savedDate;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();

    _savedDate = prefs.getString('step_date');
    _dayBaseSteps = prefs.getInt('day_base_steps');

    _sub = _service.stream.listen((event) async {
      // Gün değişti mi?
      if (_savedDate != today) {
        _savedDate = today;
        _dayBaseSteps = event.steps;

        await prefs.setString('step_date', today);
        await prefs.setInt('day_base_steps', _dayBaseSteps!);
      }

      dailySteps = event.steps - (_dayBaseSteps ?? event.steps);
      goalCompleted = dailySteps >= dailyGoal;

      notifyListeners();
    });
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
