import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'auth_service.dart';
import 'dashboard.dart';
import 'login.dart';
import 'models.dart';
import 'verify_email.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        if (!user.emailVerified) {
          return VerifyEmailPage(email: user.email);
        }

        return FutureBuilder(
          future: AuthService.loadCurrentUserProfile(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return AppStore.currentUser.isAdmin
                ? const AdminDashboardPage()
                : const DashboardPage();
          },
        );
      },
    );
  }
}
