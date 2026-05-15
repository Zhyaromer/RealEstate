import 'package:flutter/material.dart';
import 'dart:math';
import 'app_style.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'models.dart';

/// Property Loan Page
/// Allows users to apply for property loans
/// Includes loan calculator and application form
class PropertyLoanPage extends StatefulWidget {
  const PropertyLoanPage({super.key});

  @override
  State<PropertyLoanPage> createState() => _PropertyLoanPageState();
}

class _PropertyLoanPageState extends State<PropertyLoanPage> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employmentController = TextEditingController();
  final _salaryController = TextEditingController();

  /// Loan calculator values
  double _loanAmount = 5000000;
  double _interestRate = 8.5; // 8.5% per annum
  int _loanTenure = 20; // 20 years

  /// Calculated EMI
  double get _emi {
    double principal = _loanAmount;
    double monthlyRate = _interestRate / 12 / 100;
    int months = _loanTenure * 12;

    // EMI formula: P × r × (1 + r)^n / ((1 + r)^n - 1)
    double emi =
        principal *
        monthlyRate *
        pow(1 + monthlyRate, months) /
        (pow(1 + monthlyRate, months) - 1);

    return emi;
  }

  /// Total amount to be paid
  double get _totalAmount => _emi * _loanTenure * 12;

  /// Total interest
  double get _totalInterest => _totalAmount - _loanAmount;

  @override
  void initState() {
    super.initState();
    _nameController.text = AppStore.currentUser.username == 'Guest'
        ? ''
        : AppStore.currentUser.username;
    _emailController.text = AppStore.currentUser.email == 'guest@email.com'
        ? ''
        : AppStore.currentUser.email;
    _phoneController.text = AppStore.currentUser.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employmentController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  /// Handles form submission
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await FirestoreService.addLoanApplication(
        LoanApplication(
          id: '',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          employmentType: _employmentController.text.trim(),
          monthlyIncome: double.tryParse(_salaryController.text.trim()) ?? 0,
          loanAmount: _loanAmount,
          interestRate: double.parse(_interestRate.toStringAsFixed(2)),
          tenureYears: _loanTenure,
          monthlyEmi: _emi,
          status: 'Under Review',
          submittedAt: DateTime.now(),
          userId: AuthService.currentUser?.uid ?? '',
        ),
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Application Submitted'),
          content: const Text(
            'Your loan application has been submitted successfully! '
            'Our team will contact you within 2-3 business days.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to dashboard
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to submit loan application: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: Container(
        color: AppStyle.primaryDark,
        child: SafeArea(
          child: Column(
            children: [
              /// Header
              _buildHeader(),

              /// Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// Loan Calculator
                        _buildLoanCalculator(),

                        const Divider(height: 40),

                        /// Application Form
                        _buildApplicationForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds page header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Loan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Get financing for your dream home',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds loan calculator section
  Widget _buildLoanCalculator() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section title
          Row(
            children: [
              const Icon(Icons.calculate, color: AppStyle.primary),
              const SizedBox(width: 8),
              const Text(
                'Loan Calculator',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          /// Loan Amount Slider
          _buildSlider(
            label: 'Loan Amount',
            value: _loanAmount,
            min: 1000000,
            max: 50000000,
            divisions: 49,
            onChanged: (value) => setState(() => _loanAmount = value),
            displayValue: '\$${(_loanAmount / 1000000).toStringAsFixed(1)}M',
          ),
          const SizedBox(height: 20),

          /// Interest Rate Slider
          _buildSlider(
            label: 'Interest Rate',
            value: _interestRate,
            min: 6.5,
            max: 12.0,
            divisions: 55,
            onChanged: (value) => setState(() => _interestRate = value),
            displayValue: '${_interestRate.toStringAsFixed(2)}% p.a.',
          ),
          const SizedBox(height: 20),

          /// Loan Tenure Slider
          _buildSlider(
            label: 'Loan Tenure',
            value: _loanTenure.toDouble(),
            min: 5,
            max: 30,
            divisions: 25,
            onChanged: (value) => setState(() => _loanTenure = value.toInt()),
            displayValue: '$_loanTenure years',
          ),
          const SizedBox(height: 32),

          /// EMI Result Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppStyle.primaryDark, AppStyle.primary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppStyle.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Monthly EMI',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${_emi.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                /// Additional details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildEmiDetail(
                      'Total Amount',
                      '\$${(_totalAmount / 1000000).toStringAsFixed(1)}M',
                    ),
                    _buildEmiDetail(
                      'Total Interest',
                      '\$${(_totalInterest / 1000000).toStringAsFixed(1)}M',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a slider with label
  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String displayValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppStyle.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// Builds EMI detail item
  Widget _buildEmiDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds application form section
  Widget _buildApplicationForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section title
            Row(
              children: [
                const Icon(Icons.assignment, color: AppStyle.primary),
                const SizedBox(width: 8),
                const Text(
                  'Loan Application',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Name field
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            /// Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'your@email.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            /// Phone field
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+91 9876543210',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            /// Employment field
            _buildTextField(
              controller: _employmentController,
              label: 'Employment Type',
              hint: 'e.g., Salaried, Self-Employed',
              icon: Icons.work,
            ),
            const SizedBox(height: 16),

            /// Salary field
            _buildTextField(
              controller: _salaryController,
              label: 'Monthly Income (\$)',
              hint: 'Enter your monthly income',
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            /// Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'We will verify your details and contact you within 2-3 business days',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Submit Application',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Builds a text field with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Email' && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
