// lib/screens/user/umrah_guide_screen.dart
import 'package:flutter/material.dart';

class UmrahGuideScreen extends StatelessWidget {
  UmrahGuideScreen({super.key});

  // Define consistent colors from the project
  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);

  // Data for the Umrah Guide, organized into sections with steps
  final List<Map<String, dynamic>> umrahSteps = [
    {
      'title': '1. Niyyah (Intention)',
      'content':
          'Start with a sincere intention (niyyah) to perform Umrah for the sake of Allah. Recite the talbiyah: "Labbaik Allahumma Labbaik..."',
      'icon': Icons.lightbulb_outline,
    },
    {
      'title': '2. Entering Ihram',
      'content':
          'Put on the state of Ihram from the designated Miqat. Men wear two unstitched white sheets. Women wear their regular modest clothes. Perform two raka’ah of nafl salah.',
      'icon': Icons.checkroom,
    },
    {
      'title': '3. Tawaf',
      'content':
          'Perform Tawaf around the Kaaba seven times, starting from the Black Stone. Recite duas and remember Allah. After Tawaf, pray two raka’ah at Maqam Ibrahim.',
      'icon': Icons.loop,
    },
    {
      'title': '4. Sa’i',
      'content':
          'Perform Sa’i by walking/jogging seven times between Safa and Marwah. Start at Safa and end at Marwah. Remember the struggle of Hajra (AS).',
      'icon': Icons.directions_walk,
    },
    {
      'title': '5. Halq or Taqseer',
      'content':
          'Conclude your Umrah by trimming or shaving your hair. Men can shave their heads (Halq) or trim it (Taqseer). Women must trim a small portion of their hair.',
      'icon': Icons.content_cut,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          "Umrah Guide",
          style: TextStyle(color: textColorPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColorPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "A step-by-step guide for your sacred journey.",
              style: TextStyle(fontSize: 16, color: textColorSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...umrahSteps.map(
              (step) => _buildGuideCard(
                title: step['title'],
                content: step['content'],
                icon: step['icon'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper function to build the guide card with an ExpansionTile
  Widget _buildGuideCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: const TextStyle(
            color: textColorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(icon, color: accentColor),
        collapsedIconColor: textColorPrimary,
        iconColor: accentColor,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              content,
              style: TextStyle(color: textColorSecondary, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
