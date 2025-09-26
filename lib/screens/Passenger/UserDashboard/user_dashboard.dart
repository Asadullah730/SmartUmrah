// lib/screens/user_dashboard.dart
// lib/screens/user_dashboard.dart
import 'package:flutter/material.dart';
import '../../user/umrah_guide_screen.dart';
// import 'package:the_smart_umrah_project/screens/user/travel_checklist_screen.dart';
import '../../user/umrah_journal_screen.dart';
import '../../user/travel_checklist_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;

  // Define consistent colors from the project
  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color navBarColor = Color(0xFF1E2A38);
  static const Color navBarSelectedItemColor = accentColor;
  static const Color navBarUnselectedItemColor = Colors.white54;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> _userFeatures = [
    {
      'title': 'Umrah Guide',
      'description': 'Audio, Videos, Duas',
      'icon': Icons.menu_book,
      'route': '/user/umrah-guide',
    },
    {
      'title': 'Travel Checklist',
      'description': 'Packing List + Notes',
      'icon': Icons.checklist,
      'route': '/user/travel-checklist',
    },
    {
      'title': 'Rules & Regulations',
      'description': 'Visa, Entry, Laws',
      'icon': Icons.gavel,
      'route': '/user/rules-regulations',
    },
    {
      'title': 'Manage Documents',
      'description': 'Passport, Visas, Tickets',
      'icon': Icons.folder_shared,
      'route': '/user/manage-documents',
    },
    {
      'title': 'Transportation Routes',
      'description': 'Bus/Taxi Schedules & Booking',
      'icon': Icons.directions_bus,
      'route': '/user/transportation',
    },
    {
      'title': 'Umrah Journal',
      'description': 'Create & Save Memories',
      'icon': Icons.book,
      'route': '/user/umrah-journal',
    },
    {
      'title': 'Track Expenses',
      'description': 'Manage your spending',
      'icon': Icons.paid,
      'route': '/user/track-expenses',
    },
    {
      'title': 'Tawaf & Sai Counter',
      'description': 'Keep track of your rounds',
      'icon': Icons.loop,
      'route': '/user/tawaf-sai-counter',
    },
    {
      'title': 'View Places',
      'description': 'Hotels, Restaurants, Markets, Ziarats',
      'icon': Icons.place,
      'route': '/user/view-places',
    },
    {
      'title': 'Notifications',
      'description': 'View important alerts',
      'icon': Icons.notifications,
      'route': '/user/notifications',
    },
    {
      'title': 'Offline Guide Access',
      'description': 'Access guide without internet',
      'icon': Icons.wifi_off,
      'route': '/user/offline-guide',
    },
    {
      'title': 'View Travel Agent',
      'description': 'Contact your assigned agent/group',
      'icon': Icons.person_pin,
      'route': '/user/view-agent',
    },
  ];

  void _onFeatureTap(String route) {
    switch (route) {
      case '/user/umrah-guide':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UmrahGuideScreen()),
        );
        break;
      case '/user/travel-checklist':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TravelChecklistScreen(),
          ),
        );
        break;
      case '/user/umrah-journal':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UmrahJournalScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to $route (Feature not yet implemented)'),
          ),
        );
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Assalamu Alaikum, Pilgrim!",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColorPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Ready for your blessed journey?",
            style: TextStyle(fontSize: 16, color: textColorSecondary),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.9,
            ),
            itemCount: _userFeatures.length,
            itemBuilder: (context, index) {
              final feature = _userFeatures[index];
              return _buildDashboardCard(
                context,
                icon: feature['icon'],
                title: feature['title'],
                description: feature['description'],
                onTap: () => _onFeatureTap(feature['route']),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJournalContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 80, color: accentColor),
          const SizedBox(height: 20),
          Text(
            "Umrah Journal",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColorPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Document your spiritual journey here.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textColorSecondary),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UmrahJournalScreen(),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: textColorPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("New Entry"),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: accentColor),
          const SizedBox(height: 20),
          Text(
            "Settings",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColorPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Manage your preferences and app configurations.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textColorSecondary),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opening detailed settings!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: textColorPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Go to Settings"),
          ),
        ],
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
              Icon(icon, size: 50, color: accentColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          "User Dashboard",
          style: TextStyle(color: textColorPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: textColorPrimary),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out as User')),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          _buildJournalContent(),
          _buildSettingsContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: navBarSelectedItemColor,
        unselectedItemColor: navBarUnselectedItemColor,
        backgroundColor: navBarColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
