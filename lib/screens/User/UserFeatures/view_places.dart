import 'package:flutter/material.dart';

class ViewPlacesScreen extends StatelessWidget {
  const ViewPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "VIEW PLACES",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
        ),
      ),
    );
  }
}
