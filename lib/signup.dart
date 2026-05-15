import 'package:flutter/material.dart';
import 'auth_widgets.dart';
import 'models.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields', Colors.red);
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email', Colors.red);
      return;
    }

    if (phone.length < 8) {
      _showMessage('Please enter a valid phone number', Colors.red);
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters', Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);
    AppStore.currentUser = UserProfile(
      username: username,
      email: email,
      phone: phone,
    );
    Navigator.pushReplacementNamed(context, '/verify-email', arguments: email);
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create Account',
      subtitle: 'Join RealEstate and start finding homes',
      icon: Icons.person_add_alt_1_rounded,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your details to continue',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          AuthTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Your name',
            icon: Icons.person_outline_rounded,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'your@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '+964 750 000 0000',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 14),
          AuthTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Create a password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            enabled: !_isLoading,
            suffixIcon: IconButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          const SizedBox(height: 22),
          AuthPrimaryButton(
            label: 'Create Account',
            icon: Icons.arrow_forward_rounded,
            isLoading: _isLoading,
            onPressed: _handleSignUp,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
