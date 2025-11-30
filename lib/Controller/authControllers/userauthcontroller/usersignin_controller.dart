import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_umrah_app/routes/routes.dart';

enum AccountType { user, agent }

class SigninController extends GetxController {
  /// Login user or agent
  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
    AccountType accountType,
  ) async {
    try {
      // Step 1: Sign in directly
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = userCredential.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Step 2: Check email verification
      if (!user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email first, then log in.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Step 3: Check the appropriate Firestore collection
      String collection = accountType == AccountType.user
          ? 'Users'
          : 'TravelAgents';

      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.uid)
          .get();

      if (!profileSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              accountType == AccountType.user
                  ? 'This account is not registered as a User.'
                  : 'This account is not registered as an Agent.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Step 4: Save info locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isEmailVerified', true);
      await prefs.setString('userEmail', user.email ?? '');
      await prefs.setString('userUID', user.uid);
      await prefs.setString('accountType', accountType.name);

      // Step 5: Navigate to appropriate dashboard
      if (accountType == AccountType.user) {
        print('MOUNTED OR NOT :${context.mounted}');
        if (context.mounted) {
          print('User logged in: ${user.email}');
          print('User Password: ${user.updatePassword(password)}');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User logged in successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Get.toNamed(AppRoutes.userdashboard);
        }
      } else {
        Get.toNamed(AppRoutes.agentdashboard);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found for this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
