import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF8FAFD);
  static const Color cardBackground = Colors.white;

  static const Gradient tremorGradient = LinearGradient(
    colors: [
      Color(0xFFFF9171),
      Color(0xFFFF5E8E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color pink = Color(0xFFFFE5E9);
  static const Color blue = Color(0xFFE5F0FF);
  static const Color green = Color(0xFFE6F7ED);
  static const Color purple = Color(0xFFEDE7FF);

  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF6B7280);
}
