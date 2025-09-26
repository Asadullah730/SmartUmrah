import 'package:flutter/material.dart';

class TravelAgentDashboardScreen extends StatelessWidget {
  const TravelAgentDashboardScreen({super.key});
  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);
  List<Map<String, dynamic>> get _agentFeatures => [
    {
      'title': 'Register Profile',
      'icon': Icons.person_add,
      'description': 'Create new agent profile',
      'route': '/agent/register-profile', // Placeholder route
    },
    {
      'title': 'Manage Profile',
      'icon': Icons.person,
      'description': 'Edit agent details',
      'route': '/agent/manage-profile', // Placeholder route
    },
    {
      'title': 'Manage Pilgrim Group',
      'icon': Icons.groups,
      'description': 'View and organize groups',
      'route': '/agent/manage-group', // Placeholder route
    },
    {
      'title': 'Generate Schedule',
      'icon': Icons.calendar_month,
      'description': 'Create Umrah itineraries',
      'route': '/agent/generate-schedule', // Placeholder route
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications,
      'description': 'View & send alerts',
      'route': '/agent/notifications', // Placeholder route
    },
    {
      'title': 'In-app Messaging',
      'icon': Icons.message,
      'description': 'Communicate with pilgrims',
      'route': '/agent/messaging', // Placeholder route
    },
    {
      'title': 'Book Hotel & Transport',
      'icon': Icons.hotel,
      'description': 'Arrange accommodations & travel',
      'route': '/agent/book-services', // Placeholder route
    },
  ];

  void _handleFeatureTap(BuildContext context, String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to $route (Not implemented yet)')),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/travel-agent-login');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logged out as Travel Agent')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          "Travel Agent Dashboard",
          style: TextStyle(color: textColorPrimary),
        ),
        iconTheme: const IconThemeData(
          color: textColorPrimary,
        ), // For the back button if any
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: textColorPrimary),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.9, 
            ),
            itemCount: _agentFeatures.length,
            itemBuilder: (context, index) {
              final feature = _agentFeatures[index];
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardBackgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: accentColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textColorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
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
