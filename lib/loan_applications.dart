import 'package:flutter/material.dart';
import 'app_style.dart';
import 'firestore_service.dart';
import 'models.dart';
import 'property_loan.dart';

class LoanApplicationsPage extends StatefulWidget {
  const LoanApplicationsPage({super.key});

  @override
  State<LoanApplicationsPage> createState() => _LoanApplicationsPageState();
}

class _LoanApplicationsPageState extends State<LoanApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: StreamBuilder<List<LoanApplication>>(
                stream: FirestoreService.loanApplicationsStream(),
                builder: (context, snapshot) {
                  final applications = snapshot.data ?? [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (applications.isEmpty) return _buildEmptyState();
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      return _buildApplicationCard(applications[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppStyle.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.16),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Applications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Track the requests you submitted',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PropertyLoanPage()),
              );
              if (mounted) setState(() {});
            },
            icon: const Icon(Icons.add_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppStyle.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(LoanApplication application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance_outlined,
                  color: AppStyle.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${application.loanAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Submitted ${_formatDate(application.submittedAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(application.status),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildMetric('EMI', '\$${application.monthlyEmi.toStringAsFixed(0)}'),
              _buildMetric('Rate', '${application.interestRate}%'),
              _buildMetric('Tenure', '${application.tenureYears}y'),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 10),
          _buildDetail(Icons.person_outline, application.name),
          const SizedBox(height: 8),
          _buildDetail(Icons.mail_outline, application.email),
          const SizedBox(height: 8),
          _buildDetail(Icons.work_outline, application.employmentType),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.orange.shade800,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.request_quote_outlined,
              size: 78,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No applications yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Submit a loan application and track it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PropertyLoanPage()),
                );
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Apply for Loan'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
