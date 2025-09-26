import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:smart_umrah_app/routes/routes.dart';
import 'firebase_options.dart';

import 'screens/landing_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/user_login_screen.dart';
import 'screens/Admin/admin_dashboard.dart';
import 'screens/User/UserDashboard/user_dashboard.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartUmrahApp());
}

class SmartUmrahApp extends StatelessWidget {
  const SmartUmrahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Umrah Application',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0XFF263442)),
      ),
      initialRoute: AppRoutes.landingscreen,
      getPages: AppRoutes().getpags,
    );
  }
}
