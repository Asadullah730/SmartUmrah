import 'package:flutter/material.dart';

class ManageDocs extends StatelessWidget {
  const ManageDocs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Manage DOCUMENTS",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
        ),
      ),
    );
  }
}
