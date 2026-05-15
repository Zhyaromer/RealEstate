import 'package:flutter/material.dart';
import 'auth_widgets.dart';

/// Login page widget
/// Provides email/password authentication UI
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Controllers to manage text input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// State variables
  bool _obscurePassword = true; // Toggle password visibility
  bool _isLoading = false; // Show loading indicator

  @override
  void dispose() {
    /// Clean up controllers when widget is removed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates email format using regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields', Colors.red);
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email', Colors.red);
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
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'RealEstate',
      subtitle: 'Find your dream home faster',
      icon: Icons.home_rounded,
      child: _buildLoginContent(),
    );
  }

  Widget _buildLoginContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),
        _buildEmailField(),
        const SizedBox(height: 14),
        _buildPasswordField(),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _isLoading
                ? null
                : () => Navigator.pushNamed(context, '/forgot-password'),
            child: const Text('Forgot Password?'),
          ),
        ),
        const SizedBox(height: 10),
        _buildLoginButton(),
        const SizedBox(height: 16),
        _buildSignUpLink(),
      ],
    );
  }

  Widget _buildEmailField() {
    return AuthTextField(
      controller: _emailController,
      label: 'Email',
      hint: 'your@email.com',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      enabled: !_isLoading,
    );
  }

  Widget _buildPasswordField() {
    return AuthTextField(
      controller: _passwordController,
      label: 'Password',
      hint: 'Enter your password',
      icon: Icons.lock_outline_rounded,
      obscureText: _obscurePassword,
      enabled: !_isLoading,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: _isLoading
            ? null
            : () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
      ),
    );
  }

  Widget _buildLoginButton() {
    return AuthPrimaryButton(
      label: 'Sign In',
      icon: Icons.login_rounded,
      isLoading: _isLoading,
      onPressed: _isLoading ? null : _handleLogin,
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/signup'),
          child: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
