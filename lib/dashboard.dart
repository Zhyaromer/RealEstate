import 'package:flutter/material.dart';
import 'app_style.dart';
import 'loan_applications.dart';
import 'models.dart';
import 'my_properties.dart';
import 'properties.dart';
import 'property_loan.dart';
import 'rent_property.dart';
import 'saved_houses.dart';
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
                      icon: Icons.favorite_border_rounded,
                      title: 'Saved Houses',
                      subtitle: 'Review homes you saved while browsing',
                      count: '${AppStore.savedProperties.length} saved',
                      color: AppStyle.primary,
                      page: const SavedHousesPage(),
                    ),
                    const SizedBox(height: 14),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppStore.currentUser.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _buildProfileMenu(context),
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
                    '${AppStore.savedProperties.length}',
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

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'info') {
          _showUserInfo(context);
        } else if (value == 'logout') {
          _confirmLogout(context);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'info',
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded),
              SizedBox(width: 10),
              Text('Info'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppStyle.danger),
              SizedBox(width: 10),
              Text('Logout'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person_outline_rounded, color: Colors.white),
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

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppStyle.danger),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _showUserInfo(BuildContext context) async {
    final user = AppStore.currentUser;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Profile Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoLine(Icons.person_outline_rounded, 'Username', user.username),
            const SizedBox(height: 12),
            _buildInfoLine(Icons.email_outlined, 'Email', user.email),
            const SizedBox(height: 12),
            _buildInfoLine(Icons.phone_outlined, 'Phone', user.phone),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLine(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppStyle.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}
