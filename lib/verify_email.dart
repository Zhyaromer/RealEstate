import 'package:flutter/material.dart';
import 'auth_widgets.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isLoading = false;

  Future<void> _handleVerified() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _resendEmail(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification email resent to $email'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;

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
                : () => Navigator.pushReplacementNamed(context, '/signup'),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
