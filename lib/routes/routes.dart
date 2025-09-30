import 'package:get/get.dart';
import 'package:smart_umrah_app/screens/Admin/dashbord.dart';
import 'package:smart_umrah_app/screens/TravelAgent/auth_pages/agentSignIn.dart';
import 'package:smart_umrah_app/screens/TravelAgent/auth_pages/agentSignupScreen.dart';
import 'package:smart_umrah_app/screens/TravelAgent/travel_agent_dashboard.dart';
import 'package:smart_umrah_app/screens/User/UserDashboard/user_dashboard.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/TawafSaiCounter/tawaf_sai_counter.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/manage_docs.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/notification.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/offline_guide_access.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/rule.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/track_expenses.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/transport_routes.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/ViewPlace/view_places.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/view_travel_agent.dart';
import 'package:smart_umrah_app/screens/User/auth_pages/forgot_password_screen.dart';
import 'package:smart_umrah_app/screens/User/auth_pages/userSignIn.dart';
import 'package:smart_umrah_app/screens/User/auth_pages/userSignupScreen.dart';
import 'package:smart_umrah_app/screens/landing_screen.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/travel_checklist_screen.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/UmrahGuide/umrah_guide_screen.dart';
import 'package:smart_umrah_app/screens/User/UserFeatures/umrah_journal_screen.dart';

class AppRoutes {
  // User Side Routes
  static const String landingscreen = '/';
  static const String userregister = '/register';
  static const String usersignin = '/usersignin';
  static const String userdashboard = '/userdashboard';
  static const String admindashboard = '/admindashboard';
  static const String forgotpassword = '/forgotpassword';

  // User Features Routes
  static const String umrahguide = '/umrahguide';
  static const String travelchecklist = '/travelchecklist';
  static const String umrahjournal = '/umrahjournal';
  static const String umrahrules = '/rules';
  static const String managedoc = '/managedocs';
  static const String transportroutes = '/transportroutes';
  static const String trackexpenses = '/trackexpenses';
  static const String tawafsaicounter = '/tawafsaicounter';
  static const String viewplaces = '/viewplaces';
  static const String usernotification = '/usersidenotification';
  static const String userofflineaccess = '/userofflineaccess';
  static const String viewtravelagent = '/view_travel_agent';

  // Travel Agent Side Routes
  static const String agentregister = '/agentregister';
  static const String agentsignin = '/agentsignin';
  static const String agentdashboard = '/agentdashboard';

  final getpags = [
    // User Side Pages
    GetPage(name: landingscreen, page: () => LandingScreen()),
    GetPage(name: usersignin, page: () => UserSignInScreen()),
    GetPage(name: userregister, page: () => UserSignUpScreen()),
    GetPage(name: userdashboard, page: () => UserDashboard()),
    GetPage(name: usersignin, page: () => AdminDashboard()),
    GetPage(name: forgotpassword, page: () => ForgotPasswordScreen()),

    // User Features Pages
    GetPage(name: umrahguide, page: () => UmrahGuideScreen()),
    GetPage(name: travelchecklist, page: () => TravelChecklistScreen()),
    GetPage(name: umrahjournal, page: () => UmrahJournalScreen()),
    GetPage(name: umrahrules, page: () => UmrahRulesScreen()),
    GetPage(name: managedoc, page: () => ManageDocScreen()),
    GetPage(name: transportroutes, page: () => TransportRoutes()),
    GetPage(name: trackexpenses, page: () => TrackExpenses()),
    GetPage(name: tawafsaicounter, page: () => TawafSaiCounter()),
    GetPage(name: viewplaces, page: () => ViewPlaceScreen()),
    GetPage(name: usernotification, page: () => NotificationScreen()),
    GetPage(name: userofflineaccess, page: () => OfflineGuideAccess()),
    GetPage(name: viewtravelagent, page: () => ViewTravelAgent()),

    // Travel Agent Side Pages
    GetPage(name: agentregister, page: () => TravelAgentSignUpScreen()),
    GetPage(name: agentsignin, page: () => AgentSignInScreen()),
    GetPage(name: agentdashboard, page: () => TravelAgentDashboardScreen()),
  ];
}
