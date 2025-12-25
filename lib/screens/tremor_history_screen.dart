import 'package:flutter/material.dart';
import 'package:tremor_app/screens/menu_screen.dart';

class TremorHistoryScreen extends StatefulWidget {
  const TremorHistoryScreen({super.key});

  @override
  State<TremorHistoryScreen> createState() => _TremorHistoryScreenState();
}

class _TremorHistoryScreenState extends State<TremorHistoryScreen> {
  bool isToday = true;

  // ---- DATA ----

  final todayData = [
    7.0, 6.2, 5.5, 7.5, 4.0, 3.5, 8.8, 7.0,
    6.5, 5.0, 4.2, 9.0, 6.8, 7.2, 5.8
  ];

  final weekData = [6.8, 6.0, 3.8, 2.5, 7.2, 6.9, 5.5];
  final weekLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
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
              "Tremor History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // SEGMENT (TODAY / THIS WEEK)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isToday = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: isToday
                            ? const LinearGradient(
                                colors: [Color(0xff2D9CFF), Color(0xffA45CFF)],
                              )
                            : null,
                        color: isToday ? null : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Today",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isToday = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: isToday
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xff2D9CFF), Color(0xffA45CFF)],
                              ),
                        color: isToday ? Colors.grey.shade200 : null,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "This Week",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.black54 : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // CHART
            _chartContainer(
              isToday ? todayData : weekData,
              isToday ? null : weekLabels,
            ),

            const SizedBox(height: 20),

            // STATS (Average / Lowest / Highest)
            Row(
              children: [
                Expanded(
                  child: _statCard("Average", isToday ? "6.7" : "5.7", Colors.blue.shade50),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard("Lowest", isToday ? "3.0" : "2.5", Colors.pink.shade50),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard("Highest", isToday ? "9.7" : "7.5", Colors.red.shade50),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // INSIGHTS BOX
            _insightsCard(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // CHART CONTAINER
  // ---------------------------------------------------------
  Widget _chartContainer(List<double> values, List<String>? labels) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _BarChartPainter(values),
            ),
          ),

          if (labels != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels
                  .map(
                    (e) => Text(
                      e,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // STAT CARD
  // ---------------------------------------------------------
  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // INSIGHTS CARD
  // ---------------------------------------------------------
  Widget _insightsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Insights",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 14),
          Text("• Tremor levels lowest in morning hours"),
          SizedBox(height: 6),
          Text("• 15% improvement from last week"),
          SizedBox(height: 6),
          Text("• Peak activity between 2–4 PM"),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// CUSTOM BAR CHART PAINTER
// ---------------------------------------------------------
class _BarChartPainter extends CustomPainter {
  final List<double> values;

  _BarChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / (values.length * 3);

    final spacing = size.width / values.length;

    for (int i = 0; i < values.length; i++) {
      final value = values[i] / 10; // normalize 0–1 arası
      final barHeight = value * size.height * 0.8;

      final shader = const LinearGradient(
        colors: [Color(0xff2D9CFF), Color(0xffA45CFF)],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromLTWH(0, 0, 0, barHeight));

      paint.shader = shader;

      final x = spacing * i + spacing / 2;

      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
