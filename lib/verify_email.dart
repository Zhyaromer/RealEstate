import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'auth_widgets.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, this.email});

  final String? email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isLoading = false;

  Future<void> _handleVerified() async {
    try {
      setState(() => _isLoading = true);
      final isVerified = await AuthService.checkEmailVerified();

      if (!mounted) return;
      if (isVerified) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _showMessage('Your email is not verified yet.', Colors.orange);
      }
    } catch (error) {
      if (!mounted) return;
      _showMessage(AuthService.friendlyError(error), Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendEmail(String email) async {
    try {
      setState(() => _isLoading = true);
      await AuthService.resendVerificationEmail();

      if (!mounted) return;
      _showMessage('Verification email resent to $email', Colors.green);
    } catch (error) {
      if (!mounted) return;
      _showMessage(AuthService.friendlyError(error), Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeEmail = ModalRoute.of(context)?.settings.arguments as String?;
    final email = widget.email ?? routeEmail;

    return AuthScaffold(
      title: 'Verify Email',
      subtitle: 'Check your inbox to finish creating your account',
      icon: Icons.mark_email_read_outlined,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mail_outline_rounded,
              color: Colors.blue.shade800,
              size: 42,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Email Verification',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            email == null
                ? 'We sent a verification link to your email address.'
                : 'We sent a verification link to $email.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 26),
          AuthPrimaryButton(
            label: "I'm Verified",
            icon: Icons.verified_rounded,
            isLoading: _isLoading,
            onPressed: _handleVerified,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : () => _resendEmail(email ?? 'you'),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Resend'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _isLoading
                ? null
                : () async {
                    await AuthService.signOut();
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}
