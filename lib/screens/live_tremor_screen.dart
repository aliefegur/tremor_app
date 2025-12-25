import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tremor_app/screens/menu_screen.dart';

class LiveTremorScreen extends StatelessWidget {
  const LiveTremorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Real-Time Tremor Tracking",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            _tremorChartCard(),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                MetricCard(
                  title: "Current",
                  value: "4.1",
                  color1: Color(0xffF4E8FF),
                  color2: Color(0xffEFE4FF),
                ),
                MetricCard(
                  title: "Average",
                  value: "5.4",
                  color1: Color(0xffE5F0FF),
                  color2: Color(0xffE8F2FF),
                ),
                MetricCard(
                  title: "Peak",
                  value: "10.0",
                  color1: Color(0xffFFE5EA),
                  color2: Color(0xffFFE8EE),
                ),
              ],
            ),

            const SizedBox(height: 22),

            _intensityScalePanel(),
          ],
        ),
      ),
    );
  }
}

//
// 🔥 TOP GRADIENT CHART CARD
//
Widget _tremorChartCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xffD85DFD),
          Color(0xffFF4F8B),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Current Intensity",
            style: TextStyle(color: Colors.white, fontSize: 14)),

        const SizedBox(height: 6),

        const Text(
          "4.1",
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
            SizedBox(width: 6),
            Text("Recording",
                style: TextStyle(color: Colors.white, fontSize: 13)),
            SizedBox(width: 4),
            Text("Last 30 seconds",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 90,
          child: CustomPaint(
            painter: WavePainter(),
          ),
        ),
      ],
    ),
  );
}

//
// 🔥 METRIC CARD (Current / Average / Peak)
//
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color1;
  final Color color2;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🔥 INTENSITY SCALE PANEL
//
Widget _intensityScalePanel() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 12,
          offset: Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Intensity Scale",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        _scaleItem(color: Colors.green, title: "Low", range: "0–3"),
        const SizedBox(height: 10),
        _scaleItem(
          color: Colors.orange,
          title: "Moderate",
          range: "3–6",
          showIcon: true,
        ),
        const SizedBox(height: 10),
        _scaleItem(
            color: Colors.deepOrangeAccent, title: "High", range: "6–10"),
      ],
    ),
  );
}

Widget _scaleItem({
  required Color color,
  required String title,
  required String range,
  bool showIcon = false,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xffF8F9FB),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15)),
            Text(range,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black45)),
          ],
        ),
        const Spacer(),
        if (showIcon)
          const Icon(Icons.monitor_heart, color: Colors.black45),
      ],
    ),
  );
}

//
// 🔥 WAVEFORM PAINTER (DUMMY)
//
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * .6);

    for (double x = 0; x < size.width; x += 15) {
      final y = size.height * (0.5 + 0.2 * sin(x / 25));
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
