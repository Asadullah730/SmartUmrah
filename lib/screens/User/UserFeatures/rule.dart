import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_umrah_app/ColorTheme/color_theme.dart';
import 'package:smart_umrah_app/DataLayer/User/Rulesandregulation/rules_regulation.dart';

class UmrahRulesScreen extends StatelessWidget {
  const UmrahRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Umrah Rules & Regulations",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        centerTitle: true,
        backgroundColor: ColorTheme.background,
        elevation: 4,
      ),
      body: Container(
        color: ColorTheme.background,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Religious Rules",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            ...umrahRules.map(
              (rule) => Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.teal.shade100,
                    child: Icon(rule["icon"] as IconData, color: Colors.teal),
                  ),
                  title: Text(
                    rule["title"].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      rule["desc"].toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Travel & Documentation Rules",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            ...travelRules.map(
              (item) => Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.teal,
                    size: 28,
                  ),
                  title: Text(item, style: const TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.back();
        },
        label: const Text("Back"),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
