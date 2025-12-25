import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tremor_app/state/step_state.dart';
import 'package:tremor_app/screens/menu_screen.dart';

class DailySummaryScreen extends StatelessWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stepState = context.watch<DailyStepState>();
    final steps = stepState.dailySteps;
    final completed = stepState.goalCompleted;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
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
              "Daily Summary",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _todayText(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            _tremorScoreCard(),
            const SizedBox(height: 20),

            // ❤️ Heart Rate + 👣 Steps (GERÇEK VERİ)
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    icon: Icons.favorite_border,
                    title: "Heart Rate",
                    value: "72 bpm",
                    subtitle: "Normal",
                    iconColor: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _metricCard(
                    icon: completed
                        ? Icons.check_circle
                        : Icons.directions_walk,
                    title: "Steps",
                    value: completed ? "$steps ✓" : "$steps",
                    subtitle: completed
                        ? "Daily goal completed"
                        : "Goal: 6000 steps",
                    iconColor:
                        completed ? const Color(0xff0FB57A) : Colors.blueAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 🌙 Sleep + 📊 Activity
            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    icon: Icons.bedtime,
                    title: "Sleep Quality",
                    value: "7.2 hrs",
                    subtitle: "Good",
                    iconColor: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _metricCard(
                    icon: Icons.show_chart,
                    title: "Activity",
                    value: "78%",
                    subtitle: "+5%",
                    iconColor: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            _moodCheckCard(),
            const SizedBox(height: 20),
            _medicationComplianceCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  Widget _tremorScoreCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xff5B89FF), Color(0xffC85CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Today's Tremor Score",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Text("4.2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(
            "Average\n↓ 0.8 from yesterday",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScoreColumn(label: "Morning", value: "3.8"),
              _ScoreColumn(label: "Afternoon", value: "4.5"),
              _ScoreColumn(label: "Evening", value: "4.3"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 3),
          Text(title,
              style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(subtitle,
              style: const TextStyle(color: Colors.black45, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _moodCheckCard() {
    final moods = ["😊", "😐", "😴", "😨", "😴"];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mood Check",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods
                .map((m) => Text(m, style: const TextStyle(fontSize: 26)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _medicationComplianceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Medication Compliance",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          SizedBox(height: 20),
          LinearProgressIndicator(
            value: 1,
            color: Color(0xff0FB57A),
            backgroundColor: Color(0xffE0F2EC),
          ),
        ],
      ),
    );
  }

  static String _todayText() {
    final now = DateTime.now();
    return "${_weekday(now.weekday)}, ${now.day} ${_month(now.month)} ${now.year}";
  }

  static String _weekday(int d) =>
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][d - 1];

  static String _month(int m) => [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ][m - 1];
}

// -----------------------------------------------------------
class _ScoreColumn extends StatelessWidget {
  final String label;
  final String value;
  const _ScoreColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
