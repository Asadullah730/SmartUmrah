import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_umrah_app/routes/routes.dart';

class SigninController extends GetxController {
  Future<void> loginUser(
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

      if (email == "admin@gmail.com" && password == "admin123") {
        Get.toNamed(AppRoutes.admindashboard);
        return;
      }

      // Step 2: Check if user is not null and email is verified
      if (user != null && user.emailVerified) {
        // Step 3: Save info locally (optional but helpful)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isEmailVerified', true);
        await prefs.setString('userEmail', user.email ?? '');
        await prefs.setString('userUID', user.uid);

        DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
            .collection('Profiles') // 🔁 Must match your Firestore collection
            .doc(user.uid)
            .get();

        if (profileSnapshot.exists) {
          Get.toNamed(AppRoutes.userdashboard);
        } else {
          // Get.toNamed(AppRoutes.createProfile);
        }
      } else {
        // 🚨 Email not verified
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
      // 🎯 Handle Firebase-specific errors
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
      // 🔥 Catch all other errors
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
