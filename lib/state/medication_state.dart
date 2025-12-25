import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'medication_model.dart';

class MedicationState extends ChangeNotifier {
  static const _kDate = 'med_date';
  static const _kList = 'med_list';

  final List<Medication> _meds = [];
  List<Medication> get meds => List.unmodifiable(_meds);

  int get takenCount => _meds.where((m) => m.taken).length;

  // 🔮 NEXT MEDICATION
  Medication? get nextMedication {
    final now = DateTime.now();
    Medication? closest;
    Duration? diffMin;

    for (final med in _meds) {
      if (med.taken) continue;

      final t = _parseTimeToday(med.time);
      if (t == null || t.isBefore(now)) continue;

      final diff = t.difference(now);
      if (diffMin == null || diff < diffMin) {
        diffMin = diff;
        closest = med;
      }
    }
    return closest;
  }

  DateTime? _parseTimeToday(String time) {
    try {
      final now = DateTime.now();
      final parts = time.split(":");
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  // 🚀 INIT
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayKey();
    final savedDate = prefs.getString(_kDate);

    if (savedDate != today) {
      await prefs.setString(_kDate, today);
      await _loadFromPrefs(resetTaken: true);
    } else {
      await _loadFromPrefs(resetTaken: false);
    }
    notifyListeners();
  }

  // ➕ ADD
  Future<void> addMedicine({
    required String name,
    required String mg,
    required String time,
  }) async {
    _meds.add(Medication(name: name, mg: mg, time: time));
    await _saveToPrefs();
    notifyListeners();
  }

  // ✏️ UPDATE
  Future<void> updateMedicine({
    required int index,
    required String name,
    required String mg,
    required String time,
  }) async {
    _meds[index]
      ..name = name
      ..mg = mg
      ..time = time;
    await _saveToPrefs();
    notifyListeners();
  }

  // 🗑️ DELETE  🔴 (HATA BURADAYDI)
  Future<void> deleteMedicine({required int index}) async {
    _meds.removeAt(index);
    await _saveToPrefs();
    notifyListeners();
  }

  // ✅ TAKEN
  Future<void> toggleTaken(int index) async {
    _meds[index].taken = !_meds[index].taken;
    await _saveToPrefs();
    notifyListeners();
  }

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _meds.map((m) => m.toJson()).toList();
    await prefs.setString(_kList, jsonEncode(data));
  }

  Future<void> _loadFromPrefs({required bool resetTaken}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kList);
    _meds.clear();
    if (raw == null) return;

    for (final e in jsonDecode(raw)) {
      _meds.add(Medication.fromJson(e, resetTaken: resetTaken));
    }
  }
}
