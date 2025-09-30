import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_umrah_app/routes/routes.dart';

class AgentSigninController extends GetxController {
  Future<void> AgentloginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Step 1: Sign in the user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = userCredential.user;

      print("USER : $user");
      if (user != null && user.emailVerified) {
        // Step 3: Save info locally (optional but helpful)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isEmailVerified', true);
        await prefs.setString('userEmail', user.email ?? '');
        await prefs.setString('userUID', user.uid);

        DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
            .collection('TravelAgents')
            .doc(user.uid)
            .get();

        if (profileSnapshot.exists) {
          Get.toNamed(AppRoutes.agentdashboard);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please verify your email first, then log in.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white, backgroundColor: Colors.red),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: TextStyle(color: Colors.white, backgroundColor: Colors.red),
          ),
        ),
      );
    }
  }
}
