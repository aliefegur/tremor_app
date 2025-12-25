import 'package:flutter/material.dart';
import 'package:tremor_app/screens/menu_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double sensitivity = 5;
  bool vibration = true;
  bool pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
              "Settings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // -------- Tremor Sensitivity --------
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tremor Sensitivity",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Low", style: TextStyle(color: Colors.black54)),
                      Text("High", style: TextStyle(color: Colors.black54)),
                    ],
                  ),

                  Slider(
                    value: sensitivity,
                    min: 1,
                    max: 10,
                    activeColor: const Color(0xffB15DFF),
                    inactiveColor: Colors.grey,
                    label: sensitivity.round().toString(),
                    onChanged: (v) => setState(() => sensitivity = v),
                  ),

                  Text(
                    "Adjust how sensitive the tremor detection should be",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- Alerts & Notifications --------
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Alerts & Notifications",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  _toggleRow(
                    title: "Vibration Alerts",
                    subtitle: "Vibrate for medication reminders",
                    value: vibration,
                    onChanged: (v) => setState(() => vibration = v),
                  ),

                  const SizedBox(height: 14),

                  _toggleRow(
                    title: "Push Notifications",
                    subtitle: "Receive tremor and medication alerts",
                    value: pushNotifications,
                    onChanged: (v) => setState(() => pushNotifications = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- Alert Thresholds --------
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Alert Thresholds",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  _thresholdRow(
                    title: "High Tremor Alert",
                    value: "7.0",
                  ),

                  const SizedBox(height: 12),

                  _thresholdRow(
                    title: "Low Activity Alert",
                    value: "< 2000 steps",
                    isBlue: true,
                  ),

                  const SizedBox(height: 12),

                  _thresholdRow(
                    title: "Sleep Quality Alert",
                    value: "< 6 hrs",
                    isBlue: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- Privacy & Data --------
            _card(
              color: const Color(0xffEEF3FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Privacy & Data",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "All health data is stored securely and encrypted on your device",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "View Privacy Policy →",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ------- CARD CONTAINER -------
  Widget _card({required Widget child, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  // ------- SWITCH ROW -------
  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: const Color(0xffB15DFF),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ------- THRESHOLD ITEM -------
  Widget _thresholdRow({
    required String title,
    required String value,
    bool isBlue = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: isBlue ? Colors.blue : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
