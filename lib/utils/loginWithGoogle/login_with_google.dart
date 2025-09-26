import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          // await signInWithGoogle(context);
        } catch (e) {
          debugPrint("Error signing in with Google: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign in with Google')),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'assets/Icons/google_logo-removebg-preview.png',
              ),
              height: 20,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            const Text(
              'SignIn with Google',
              style: TextStyle(color: Color(0xFF9B5DE5)),
            ),
          ],
        ),
      ),
    );
  }
}
