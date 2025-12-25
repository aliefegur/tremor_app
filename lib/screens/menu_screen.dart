import 'package:flutter/material.dart';
import 'package:tremor_app/screens/live_tremor_screen.dart';
import 'package:tremor_app/screens/daily_summary_screen.dart';
import 'package:tremor_app/screens/tremor_history_screen.dart';
import 'package:tremor_app/screens/medication_screen.dart';
import 'package:tremor_app/screens/settings_screen.dart';
import 'package:tremor_app/screens/home_screen.dart';



class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                children: [

                  // DASHBOARD
                  _menuTile(
                    title: "Dashboard",
                    icon: Icons.home_outlined,
                    colors: const [Color(0xff7EC8E3), Color(0xff6A9CFD)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                  ),

                  // LIVE TREMOR
                  _menuTile(
                    title: "Live Tremor",
                    icon: Icons.monitor_heart,
                    colors: const [Color(0xffFF6FB5), Color(0xffFF4E8E)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LiveTremorScreen(),
                        ),
                      );
                    },
                  ),

                  // DAILY SUMMARY
                  _menuTile(
                    title: "Daily Summary",
                    icon: Icons.calendar_month,
                    colors: const [Color(0xff33CFFF), Color(0xff2880E8)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DailySummaryScreen(),
                        ),
                      );
                    },
                  ),

                  // HISTORY
                  _menuTile(
                    title: "History",
                    icon: Icons.bar_chart,
                    colors: const [Color(0xff6A9CFD), Color(0xff3A6BFF)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TremorHistoryScreen(),
                        ),
                      );
                    },
                  ),

                  // MEDICATION
                  _menuTile(
                    title: "Medication",
                    icon: Icons.medical_services_outlined,
                    colors: const [Color(0xffFF8AAE), Color(0xffFF4F7A)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicationScreen(),
                        ),
                      );
                    },
                  ),

                  // SETTINGS
                  _menuTile(
                    title: "Settings",
                    icon: Icons.settings_outlined,
                    colors: const [Color(0xffAAB0C3), Color(0xff696F80)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            

            const SizedBox(height: 20),

            // RETURN BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xff2D9CFF), Color(0xffA45CFF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Return to Dashboard",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// MENU TILE WIDGET
  Widget _menuTile({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
