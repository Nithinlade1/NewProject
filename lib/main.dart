import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/language/language_selection_screen.dart';
import 'features/welcome/welcome_screen.dart';
import 'features/auth/login/login_screen.dart';
import 'features/auth/otp/otp_screen.dart';
import 'features/auth/signup/signup_screen.dart';
import 'features/tud_number/tud_number_screen.dart';
import 'features/landing/landing_screen.dart';
import 'features/kutcom_detail/kutcom_detail_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/language_settings_screen.dart';
import 'features/settings/terms_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const EntryTudApp());
}

class EntryTudApp extends StatelessWidget {
  const EntryTudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EntryTUD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.language: (_) => const LanguageSelectionScreen(),
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.otp: (_) => const OTPScreen(),
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.tudNumber: (_) => const TudNumberScreen(),
        AppRoutes.landing: (_) => const LandingScreen(),
        AppRoutes.kutcomDetail: (_) => const KutComDetailScreen(),
        AppRoutes.chat: (_) => const ChatScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),
        AppRoutes.schedule: (_) => const ScheduleScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.languageSettings: (_) => const LanguageSettingsScreen(),
        AppRoutes.termsConditions: (_) => const TermsScreen(),
      },
    );
  }
}
