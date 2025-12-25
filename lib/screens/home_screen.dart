import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tremor_app/screens/daily_summary_screen.dart';
import 'package:tremor_app/screens/tremor_history_screen.dart';
import 'package:tremor_app/screens/medication_screen.dart';
import 'package:tremor_app/screens/live_tremor_screen.dart';
import 'package:tremor_app/screens/menu_screen.dart';
import 'package:tremor_app/services/tremor_service.dart';

import 'package:tremor_app/state/step_state.dart';
import 'package:tremor_app/state/medication_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tremorLevel = 5;
  String intensityText = "High Intensity";
  List<Color> tremorColors = [Colors.orange, Colors.pink];

  final TremorService tremorService = TremorService();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _updateTremorLevel();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateTremorLevel();
    });

    tremorService.init().then((val) {
      print("Tremor Service Intiialized!");

      final raw = List<double>.generate(
        250 * 6,
            (i) => 0.01 * (i % 6),
      );

      final processed = tremorService.preprocessor.process(raw);
      final score = tremorService.inference.run(processed);

      print('Tremor score: $score');
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 18) return "Good Afternoon";
    if (hour >= 18 && hour < 24) return "Good Evening";
    return "Good Night";
  }

  void _updateTremorLevel() {
    final random = Random();
    int newLevel = random.nextInt(10) + 1;

    setState(() {
      tremorLevel = newLevel;

      if (newLevel <= 2) {
        intensityText = "Low Intensity";
        tremorColors = [const Color(0xff00E676), const Color(0xff00C853)];
      } else if (newLevel <= 4) {
        intensityText = "Moderate Intensity";
        tremorColors = [const Color(0xffFFB74D), const Color(0xffFB8C00)];
      } else {
        intensityText = "High Intensity";
        tremorColors = [const Color(0xffFF8A80), const Color(0xffFF5252)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          getGreeting(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Here's your health overview",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 18),

            // ---------------- CURRENT TREMOR ----------------
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LiveTremorScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: tremorColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Tremor Level",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$tremorLevel/10",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.white, size: 10),
                        const SizedBox(width: 6),
                        Text(
                          intensityText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ---------------- KPI BOXES ----------------
            Row(
              children: [
                _infoBox(Icons.favorite_border, "Heart Rate", "72 bpm",
                    const Color(0xffFAD4D4)),
                const SizedBox(width: 12),

                Consumer<DailyStepState>(
                  builder: (context, stepState, _) {
                    final steps = stepState.dailySteps;
                    final completed = stepState.goalCompleted;

                    return _infoBox(
                      completed
                          ? Icons.check_circle
                          : Icons.directions_walk,
                      "Steps",
                      completed ? "$steps ✓" : "$steps steps",
                      completed
                          ? const Color(0xffDFF2D6)
                          : const Color(0xffD6E8FF),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _infoBox(Icons.speed, "Activity Score", "78 %",
                    const Color(0xffDFF2D6)),
                const SizedBox(width: 12),
                _infoBox(Icons.nightlight_round, "Sleep", "7.2 hrs",
                    const Color(0xffEAD9FF)),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- MENU CARDS ----------------
            _menuCard(
              context,
              title: "Daily Summary",
              subtitle: "View today's detailed report",
              icon: Icons.calendar_month,
              screen: const DailySummaryScreen(),
            ),
            const SizedBox(height: 12),

            _menuCard(
              context,
              title: "Tremor History",
              subtitle: "Weekly trends and insights",
              icon: Icons.bar_chart,
              screen: const TremorHistoryScreen(),
            ),
            const SizedBox(height: 12),

            Consumer<MedicationState>(
              builder: (context, medState, _) {
                final next = medState.nextMedication;

                return _menuCard(
                  context,
                  title: "Next Medication",
                  subtitle: next == null
                      ? "No medication scheduled"
                      : "${next.name} at ${next.time}",
                  icon: Icons.medication,
                  screen: const MedicationScreen(),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(IconData icon, String title, String value, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
