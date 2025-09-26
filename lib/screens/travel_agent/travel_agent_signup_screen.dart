import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_umrah_app/Screens/emailVarification.dart';

class TravelAgentSignupScreen extends StatefulWidget {
  const TravelAgentSignupScreen({super.key});
  @override
  _TravelAgentSignupScreenState createState() =>
      _TravelAgentSignupScreenState();
}

class _TravelAgentSignupScreenState extends State<TravelAgentSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Male';
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> signUpUser(
    BuildContext context, {
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password.trim() != confirmPassword.trim()) {
      _showErrorSnackBar(context, 'Passwords do not match');
      return;
    }

    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showErrorSnackBar(context, 'Email and password cannot be empty');
      return;
    }

    _isLoading = true;

    try {
      debugPrint("Attempting to sign up with email: $email");

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        debugPrint("Verification email sent to: ${user.email}");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationScreen(
            emailAddress: _emailController.text ?? email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.code} - ${e.message}");
      _showErrorSnackBar(context, _getErrorMessage(e));
    } catch (e) {
      debugPrint("Unexpected error during signup: $e");
      _showErrorSnackBar(context, 'Unexpected error: $e');
    } finally {
      _isLoading = false;
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  static const Color primaryBackgroundColor = Color(0xFF1E2A38);
  static const Color cardBackgroundColor = Color(0xFF283645);
  static const Color textColorPrimary = Colors.white;
  static const Color textColorSecondary = Colors.white70;
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color iconColor = Colors.white;
  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    String hintText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: textColorSecondary),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: cardBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: accentColor,
              onPrimary: textColorPrimary,
              surface: primaryBackgroundColor,
              onSurface: textColorPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: primaryBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textColorPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Register as Travel Agent",
          style: TextStyle(
            color: textColorPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // User Name
                TextFormField(
                  controller: _userNameController,
                  style: const TextStyle(color: textColorPrimary),
                  decoration: _inputDecoration(
                    "Agent Name",
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: iconColor,
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Agent Name is required'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _agencyController,
                  style: const TextStyle(color: textColorPrimary),
                  decoration: _inputDecoration(
                    "Agency Name",
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: iconColor,
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Agency Name is required'
                      : null,
                ),
                const SizedBox(height: 20),
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: textColorPrimary),
                  decoration: _inputDecoration(
                    "Email",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: iconColor,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email is required';
                    }
                    // Basic email validation
                    if (!val.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: textColorPrimary),
                  decoration: _inputDecoration(
                    "Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: iconColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: textColorSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password is required';
                    }
                    if (val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: textColorPrimary),
                  decoration: _inputDecoration(
                    "Confirm Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: iconColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: textColorSecondary,
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Confirm Password is required';
                    }
                    if (val != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _isLoading = true;
                      signUpUser(
                            context,
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            confirmPassword: _confirmPasswordController.text
                                .trim(),
                          )
                          .then((_) {
                            _isLoading = false;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerificationScreen(
                                  emailAddress: _emailController.text.trim(),
                                ),
                              ),
                            );
                          })
                          .catchError((error) {
                            _isLoading = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: ${error.toString()}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                    }
                    if (_formKey.currentState!.validate()) {
                      _isLoading = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "User ${_userNameController.text.trim()} Register Successfully",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Register Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColorPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: textColorSecondary,
                  ),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
