import 'package:get/get.dart';
import 'package:smart_umrah_app/screens/Admin/admin_dashboard.dart';
import 'package:smart_umrah_app/screens/Admin/dashbord.dart';
import 'package:smart_umrah_app/screens/Passenger/UserDashboard/user_dashboard.dart';
import 'package:smart_umrah_app/screens/Passenger/auth_pages/forgot_password_screen.dart';
import 'package:smart_umrah_app/screens/Passenger/auth_pages/userSignIn.dart';
import 'package:smart_umrah_app/screens/Passenger/auth_pages/userSignupScreen.dart';
import 'package:smart_umrah_app/screens/landing_screen.dart';

class AppRoutes {
  // User Side Routes
  static const String landingscreen = '/';
  static const String userregister = '/register';
  static const String usersignin = '/usersignin';
  static const String userdashboard = '/userdashboard';
  static const String admindashboard = '/admindashboard';
  static const String forgotpassword = '/forgotpassword';

  final getpags = [
    // User Side Pages
    GetPage(name: landingscreen, page: () => LandingScreen()),
    GetPage(name: usersignin, page: () => UserSignInScreen()),
    GetPage(name: userregister, page: () => UserSignUpScreen()),
    GetPage(name: userdashboard, page: () => UserDashboard()),
    GetPage(name: usersignin, page: () => AdminDashboard()),
    GetPage(name: forgotpassword, page: () => ForgotPasswordScreen()),
  ];
}
