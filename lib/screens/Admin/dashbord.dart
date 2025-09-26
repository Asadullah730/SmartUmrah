import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "ADMIN DASHBOARD",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ),
    );
  }
}
