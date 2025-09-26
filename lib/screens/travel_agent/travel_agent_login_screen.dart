import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_umrah_app/Screens/signup_screen.dart';
import 'package:smart_umrah_app/screens/travel_agent/travel_agent_dashboard.dart';
import 'package:smart_umrah_app/screens/travel_agent/travel_agent_signup_screen.dart';

import 'package:smart_umrah_app/validation/auth_validation.dart';
import 'package:smart_umrah_app/widgets/customButton.dart';

import 'package:smart_umrah_app/widgets/customtextfield.dart';

class TravelAgentLoginScreen extends StatelessWidget {
  TravelAgentLoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> loginUser(email, password, BuildContext context) async {
    try {
      // Sign in with Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // Check email verification
      if (userCredential.user?.emailVerified ?? false) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isEmailVerified', true);
        await prefs.setString('userEmail', userCredential.user?.email ?? '');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TravelAgentDashboardScreen()),
        );
      } else {
        // Show verification required message
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
      // Handle specific Firebase authentication errors
      String errorMessage = 'Login failed';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, style: TextStyle(color: Colors.red)),
        ),
      );
    } catch (e) {
      // Catch any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e', style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBackgroundColor = Color(0xFF1E2A38);
    const Color cardBackgroundColor = Color(0xFF283645);
    const Color textColorPrimary = Colors.white;
    const Color textColorSecondary = Colors.white70;
    const Color accentColor = Color(0xFF3B82F6);
    const Color iconColor = Colors.white;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/umrah_app_logo.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                customTextField(
                  "Enter Email Address",
                  controller: _emailController,
                  validator: AuthFormValidation.validateEmail,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    fillColor: Color(0xFF283645),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      AuthFormValidation.validatePassword(value),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomButton(
                  text: 'L O G I N',
                  isLoading: _isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _isLoading = true;
                      loginUser(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context,
                          )
                          .then((_) {
                            _isLoading = false;
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                            _isLoading = false;
                          });
                    }
                  },
                  width: MediaQuery.of(context).size.width * 0.5,
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const Text(
                  "Don't Have an account ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelAgentSignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
