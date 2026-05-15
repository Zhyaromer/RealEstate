import 'package:flutter/material.dart';
import 'auth_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email', Colors.red);
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email', Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);
    _showMessage('Password reset link sent to $email', Colors.green);
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset Password',
      subtitle: 'We will send recovery steps to your email',
      icon: Icons.lock_reset_rounded,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Forgot Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the email linked to your account.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          AuthTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'your@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: 'Send Reset Link',
            icon: Icons.send_rounded,
            isLoading: _isLoading,
            onPressed: _sendResetLink,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }
}
