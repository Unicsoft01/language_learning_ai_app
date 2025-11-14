import 'package:flutter/material.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/login_screen.dart';
import '../screens/onboarding/signup_screen.dart';
import '../screens/onboarding/language_selection_screen.dart';
import '../screens/onboarding/goal_setup_screen.dart';
import '../screens/onboarding/placement_test_screen.dart';
// import '../screens/home/home_screen.dart';
// import '../screens/lessons/lesson_list_screen.dart';
// import '../screens/lessons/lesson_detail_screen.dart';
// import '../screens/lessons/exercise_screen.dart';
// import '../screens/profile/profile_screen.dart';
// import '../screens/analytics/analytics_screen.dart';
// import '../screens/profile/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String languageSelect = '/language-select';
  static const String home = '/home';
  static const String lessons = '/lessons';
  static const String lessonDetail = '/lesson-detail';
  static const String exercise = '/exercise';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String setupGoals = '/setup/goals';
  static const String setupPlacement = '/setup/placement';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    languageSelect: (context) => const LanguageSelectionScreen(),
    setupGoals: (context) => const GoalSetupScreen(),
    setupPlacement: (context) => const PlacementTestScreen(),
    // home: (context) => const HomeScreen(),
    // lessons: (context) => const LessonListScreen(),
    // lessonDetail: (context) => const LessonDetailScreen(),
    // exercise: (context) => const ExerciseScreen(),
    // analytics: (context) => const AnalyticsScreen(),
    // profile: (context) => const ProfileScreen(),
    // settings: (context) => const SettingsScreen(),
  };
}
