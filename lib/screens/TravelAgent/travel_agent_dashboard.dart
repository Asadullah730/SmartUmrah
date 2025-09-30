import 'package:flutter/material.dart';
import 'package:smart_umrah_app/DataLayer/AgentData/features.dart';
import 'package:smart_umrah_app/Services/firebaseServices/AuthServices/logout.dart';

class TravelAgentDashboardScreen extends StatelessWidget {
  const TravelAgentDashboardScreen({super.key});

  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);

  void _handleFeatureTap(BuildContext context, String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to $route (Not implemented yet)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
        (screenWidth - 48) / 2; // 16 px padding + 16 spacing

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          "Travel Agent Dashboard",
          style: TextStyle(color: textColorPrimary),
        ),
        iconTheme: const IconThemeData(color: textColorPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: textColorPrimary),
            onPressed: () async => await logoutUser(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: agentFeatures.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600
                  ? 3
                  : 2, // more columns on tablet
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: cardWidth / 180, // responsive card height
            ),
            itemBuilder: (context, index) {
              final feature = agentFeatures[index];
              return _buildDashboardCard(
                context,
                icon: feature['icon'],
                title: feature['title'],
                description: feature['description'],
                onTap: () => _handleFeatureTap(context, feature['route']),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardBackgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: accentColor),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: textColorSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
