import 'package:flutter/material.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "NOTIFICATION",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
        ),
      ),
    );
  }
}
