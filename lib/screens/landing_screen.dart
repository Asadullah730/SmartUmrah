import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_umrah_app/routes/routes.dart';
import 'package:smart_umrah_app/screens/travel_agent/travel_agent_login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color titleTextColor = Color(0xFFBBBBBB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/umrah_app_logo.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 40),
                Text(
                  "Smart Umrah Application",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: titleTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your companion for a blessed journey.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: textColorSecondary),
                ),

                const SizedBox(height: 60),

                // User Login Button
                ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.usersignin),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "User Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColorPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelAgentLoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Travel Agent",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
