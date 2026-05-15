import 'package:flutter/material.dart';
import 'app_style.dart';
import 'loan_applications.dart';
import 'models.dart';
import 'my_properties.dart';
import 'properties.dart';
import 'property_loan.dart';
import 'rent_property.dart';
import 'sell_property.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopPanel(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
              sliver: SliverToBoxAdapter(
                child: _buildSectionTitle('Quick Actions'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.08,
                children: [
                  _buildActionTile(
                    context,
                    icon: Icons.search_rounded,
                    title: 'Buy',
                    subtitle: 'Explore homes',
                    color: AppStyle.primary,
                    page: const PropertiesPage(),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.sell_outlined,
                    title: 'Sell',
                    subtitle: 'List property',
                    color: AppStyle.primary,
                    page: const SellPropertyPage(),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.key_rounded,
                    title: 'Rent',
                    subtitle: 'Find rentals',
                    color: AppStyle.primary,
                    page: const RentPropertyPage(),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.account_balance_outlined,
                    title: 'Loan',
                    subtitle: 'Apply now',
                    color: AppStyle.primary,
                    page: const PropertyLoanPage(),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              sliver: SliverToBoxAdapter(
                child: _buildSectionTitle('Your Workspace'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildWorkspaceCard(
                      context,
                      icon: Icons.home_work_outlined,
                      title: 'My Properties',
                      subtitle: 'Edit, delete, and manage your listings',
                      count: '${AppStore.myProperties.length} active',
                      color: AppStyle.primary,
                      page: const MyPropertiesPage(),
                    ),
                    const SizedBox(height: 14),
                    _buildWorkspaceCard(
                      context,
                      icon: Icons.request_quote_outlined,
                      title: 'Loan Applications',
                      subtitle: 'View submitted applications and status',
                      count: '${AppStore.loanApplications.length} submitted',
                      color: AppStyle.primary,
                      page: const LoanApplicationsPage(),
                    ),
                    const SizedBox(height: 22),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppStyle.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.home_rounded, color: AppStyle.primary),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Guest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildHeroMetric(
                    'Listed',
                    '${AppStore.myProperties.length}',
                    Icons.real_estate_agent_outlined,
                  ),
                ),
                Container(width: 1, height: 46, color: Colors.white24),
                Expanded(
                  child: _buildHeroMetric(
                    'Loan Apps',
                    '${AppStore.loanApplications.length}',
                    Icons.receipt_long_outlined,
                  ),
                ),
                Container(width: 1, height: 46, color: Colors.white24),
                Expanded(
                  child: _buildHeroMetric(
                    'Saved',
                    '8',
                    Icons.favorite_border_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppStyle.text,
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _openPage(context, page),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -6,
              child: Icon(icon, color: Colors.white.withOpacity(0.18), size: 92),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 29),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String count,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _openPage(context, page),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade500),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      icon: const Icon(Icons.logout_rounded),
      label: const Text('Logout'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppStyle.danger,
        side: BorderSide(color: AppStyle.danger.withOpacity(0.18)),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _openPage(BuildContext context, Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    if (mounted) setState(() {});
  }
}
