import 'package:flutter/material.dart';

class ViewTravelAgent extends StatelessWidget {
  const ViewTravelAgent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "VIEW TRAVEL AGENT",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
        ),
      ),
    );
  }
}
