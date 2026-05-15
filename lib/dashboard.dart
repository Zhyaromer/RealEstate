import 'package:flutter/material.dart';
import 'properties.dart';
import 'sell_property.dart';
import 'rent_property.dart';
import 'property_loan.dart';

/// Dashboard page - Main hub after login
/// Shows user stats and property action cards
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// Gradient background for modern look
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade900,
              Colors.purple.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header with user name and avatar
                _buildHeader(context),
                const SizedBox(height: 32),

                /// zhmaray xanw + profit
                _buildStatsRow(),
                const SizedBox(height: 32),

                /// title
                const Text(
                  'What would you like to do?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                /// Action cards for Buy, Sell, Loan, Rent
                _buildActionCard(
                  context,
                  icon: Icons.search,
                  title: 'Buy Property',
                  description: 'Find your dream home',
                  colors: [Colors.blue.shade400, Colors.cyan.shade400],
                  onTap: () {
                    // Navigate to properties page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertiesPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildActionCard(
                  context,
                  icon: Icons.sell,
                  title: 'Sell Property',
                  description: 'List your property',
                  colors: [Colors.orange.shade400, Colors.pink.shade400],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellPropertyPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildActionCard(
                  context,
                  icon: Icons.account_balance,
                  title: 'Property Loan',
                  description: 'Get financing',
                  colors: [Colors.green.shade400, Colors.teal.shade400],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertyLoanPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildActionCard(
                  context,
                  icon: Icons.apartment,
                  title: 'Rent Property',
                  description: 'Find rentals',
                  colors: [Colors.purple.shade400, Colors.indigo.shade400],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RentPropertyPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                /// Logout button
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds header with greeting and avatar
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// User greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Guest',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        /// Profile avatar
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.shade400,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  /// Builds row of statistics cards
  Widget _buildStatsRow() {
    return Row(
      children: [
        /// Active listings stat
        Expanded(
          child: _buildStatCard(
            icon: Icons.home,
            value: '3',
            label: 'Active\nListings',
          ),
        ),
        const SizedBox(width: 16),

        /// Portfolio value stat
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            value: '\$12.5M',
            label: 'Portfolio\nValue',
          ),
        ),
      ],
    );
  }

  /// Builds a single statistics card
  /// Shows icon, value, and label
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an action card with gradient background
  /// Used for Buy, Sell, Loan, Rent options
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Icon container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),

            /// Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            /// Arrow icon
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  /// logout
  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
