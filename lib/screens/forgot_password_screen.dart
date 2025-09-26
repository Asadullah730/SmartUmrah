import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          "Recover Account",
          style: TextStyle(color: textColorPrimary), // White title
        ),
        iconTheme: const IconThemeData(
          color: textColorPrimary,
        ), // White back arrow
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter your email to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: textColorSecondary),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: textColorPrimary),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: textColorSecondary),
                  hintText: "example@email.com",
                  hintStyle: TextStyle(
                    color: textColorSecondary.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: cardBackgroundColor,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: textColorSecondary,
                  ), // Email icon
                  border: OutlineInputBorder(
                    // Default border style
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Border when focused
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: accentColor,
                      width: 2,
                    ), // Accent color on focus
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  String email = _emailController.text.trim();
                  if (email.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Recovery email sent to $email (demo)"),
                        backgroundColor: accentColor, // Themed snackbar
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Please enter your email."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: accentColor,
                  foregroundColor: textColorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Recover"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
