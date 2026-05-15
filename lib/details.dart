import 'package:flutter/material.dart';
import 'models.dart';

/// Property details page - Shows full information about a property
/// Includes image, specs, description, features, owner info, and action buttons
class PropertyDetailsPage extends StatelessWidget {
  /// The property to display
  final Property property;

  const PropertyDetailsPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// App bar with property image
          _buildAppBar(context),

          /// Property details content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title and location
                  _buildHeader(),
                  const SizedBox(height: 20),

                  /// Price card
                  _buildPriceCard(),
                  const SizedBox(height: 20),

                  /// Specs grid (area, beds, baths, rating)
                  _buildSpecsGrid(),
                  const SizedBox(height: 24),

                  /// Description section
                  _buildDescription(),
                  const SizedBox(height: 24),

                  /// Features section
                  _buildFeatures(),
                  const SizedBox(height: 24),

                  /// Owner information
                  _buildOwnerInfo(),
                  const SizedBox(height: 24),

                  /// Action buttons (Bid and Buy)
                  _buildActionButtons(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds app bar with property image and back button
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          property.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.image, size: 80),
            );
          },
        ),
      ),
    );
  }

  /// Builds property title and location
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.red.shade400, size: 20),
            const SizedBox(width: 6),
            Text(
              property.location,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds price display card
  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asking Price',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            property.formattedPrice,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds grid showing property specifications
  Widget _buildSpecsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildSpecItem(
            Icons.photo_size_select_small,
            property.formattedArea,
            'Area',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSpecItem(Icons.bed, '${property.bedrooms}', 'Beds'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSpecItem(
            Icons.bathroom,
            '${property.bathrooms}',
            'Baths',
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  /// Builds a single specification item
  Widget _buildSpecItem(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Builds description section
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Property',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          property.description,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Builds features section with chips
  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features & Amenities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: property.features.map((feature) {
            return Chip(
              label: Text(feature),
              backgroundColor: Colors.green.shade100,
              labelStyle: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(color: Colors.green.shade300),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Builds owner information card
  Widget _buildOwnerInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Owner Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              /// Owner avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),

              /// Owner details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.ownerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.ownerPhone,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              /// Call button
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds action buttons row (Make Bid and Buy Now)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        /// Make a Bid button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showBidDialog(context),
            icon: const Icon(Icons.gavel),
            label: const Text('Make a Bid'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              side: BorderSide(color: Colors.blue.shade700, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        /// Buy Now button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showBuyDialog(context),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Buy Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Shows dialog to place a bid
  void _showBidDialog(BuildContext context) {
    final bidController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Make an Offer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Place your bid for this property'),
            const SizedBox(height: 20),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Bid Amount',
                hintText: 'Enter amount in \$',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (bidController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bid of \$${bidController.text} placed!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Place Bid'),
          ),
        ],
      ),
    );
  }

  /// Shows dialog to confirm purchase
  void _showBuyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            /// Price breakdown
            _buildPriceRow('Property Price:', property.formattedPrice),
            const SizedBox(height: 8),
            _buildPriceRow(
              'Registration & Taxes:',
              '\$${(property.price * 0.08 / 1000000).toStringAsFixed(2)}M',
            ),
            const Divider(height: 24),
            _buildPriceRow(
              'Total Amount:',
              '\$${(property.price * 1.08 / 1000000).toStringAsFixed(2)}M',
              isTotal: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${property.title} purchased successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            child: const Text(
              'Complete Purchase',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for price breakdown rows
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? Colors.green.shade700 : null,
          ),
        ),
      ],
    );
  }
}
