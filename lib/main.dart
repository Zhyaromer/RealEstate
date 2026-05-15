import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'forgot_password.dart';
import 'login.dart';
import 'loan_applications.dart';
import 'my_properties.dart';
import 'signup.dart';
import 'verify_email.dart';

/// Entry point of the application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RealEstateApp());
}

/// Root widget of the application
/// Sets up theme and navigation routes
class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate',
      debugShowCheckedModeBanner: false,

      /// Modern Material 3 theme with blue color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      /// Set login page as initial screen
      home: const LoginPage(),

      /// Define named routes for easy navigation
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/verify-email': (context) => const VerifyEmailPage(),
        '/my-properties': (context) => const MyPropertiesPage(),
        '/loan-applications': (context) => const LoanApplicationsPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
