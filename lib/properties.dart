import 'package:flutter/material.dart';
import 'models.dart';
import 'details.dart';

/// Properties page - Shows list of available properties
/// Includes tab switching between Available and Purchase History
class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  /// Current selected tab (0 = Available, 1 = History)
  int _selectedTab = 0;

  /// Sample property data used as a fallback when Firestore is empty
  final List<Property> _properties = [
    Property(
      id: 'p1',
      title: 'Modern Luxury Villa',
      location: 'Mumbai, Maharashtra',
      price: 5000000,
      area: 3500,
      bedrooms: 4,
      bathrooms: 3,
      image:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/466378675.jpg?k=47439be8a91e422a1dbef4f02630d6c86f1266a815d7bd8f21b2c5ce0492bcc1&o=',
      description:
          'Stunning modern villa with panoramic views and premium finishes.',
      features: ['Pool', 'Garden', 'Gym', 'Security', 'Parking'],
      ownerName: 'Rajesh Kumar',
      ownerPhone: '+91 9876543210',
      propertyType: 'Villa',
    ),
    Property(
      id: 'p2',
      title: 'Modern Apartment',
      location: 'Bangalore, Karnataka',
      price: 3500000,
      area: 2200,
      bedrooms: 3,
      bathrooms: 2,
      image:
          'https://www.thehousedesigners.com/images/plans/01/UDC/bulk/7295/e276-gao_residence_view1_m.webp',
      description:
          'Beautiful apartment in gated community with excellent amenities.',
      features: ['Balcony', 'Lift', 'Parking', 'Club', 'Play Area'],
      ownerName: 'Priya Sharma',
      ownerPhone: '+91 9876543211',
      propertyType: 'Apartment',
    ),
    Property(
      id: 'p3',
      title: 'Beachfront Property',
      location: 'Goa, India',
      price: 7500000,
      area: 4000,
      bedrooms: 5,
      bathrooms: 4,
      image:
          'https://modernhb.com/wp-content/uploads/sites/6/2025/07/beachhousesJL25.jpeg',
      description: 'Exclusive beachfront property with private beach access.',
      features: ['Beach', 'Terrace', 'Theater', 'Wine Cellar', 'Hot Tub'],
      ownerName: 'Vikram Patel',
      ownerPhone: '+91 9876543212',
      propertyType: 'Villa',
    ),
  ];

  /// history
  final List<Map<String, dynamic>> _purchaseHistory = [
    {
      'title': 'Luxury Villa',
      'location': 'Mumbai, Maharashtra',
      'price': 5000000,
      'date': 'Dec 15, 2024',
      'status': 'Completed',
      'image':
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
    },
    {
      'title': 'City Apartment',
      'location': 'Bangalore, Karnataka',
      'price': 3500000,
      'date': 'Nov 20, 2024',
      'status': 'Completed',
      'image':
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade900],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// Header with back button and tabs
              _buildHeader(),

              /// Content area - switches based on selected tab
              Expanded(
                child: _selectedTab == 0
                    ? _buildPropertiesList()
                    : _buildPurchaseHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds header with back button, title, and tabs
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// Top row with back button and title
          Row(
            children: [
              /// Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              const Spacer(),

              /// Page title
              Text(
                _selectedTab == 0 ? 'Buy Property' : 'Purchase History',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),

              /// Filter button (placeholder)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Tab selector
          _buildTabSelector(),
          const SizedBox(height: 12),

          /// Item count
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _selectedTab == 0
                  ? '${_properties.length} Properties Available'
                  : '${_purchaseHistory.length} Purchases',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds tab selector (Available / History)
  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          /// Available tab
          Expanded(child: _buildTab('Available', 0)),

          /// History tab
          Expanded(child: _buildTab('History', 1)),
        ],
      ),
    );
  }

  /// Builds a single tab button
  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade700 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Builds list of available properties
  Widget _buildPropertiesList() {
    if (_properties.isEmpty) {
      return Center(
        child: Text(
          'No properties available yet.',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _properties.length,
      itemBuilder: (context, index) {
        return _buildPropertyCard(_properties[index]);
      },
    );
  }

  /// cardi zanyariakan
  /// Shows image, title, location, price, and bedrooms/bathrooms
  Widget _buildPropertyCard(Property property) {
    return GestureDetector(
      onTap: () {
        /// Navigate to property details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(property: property),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Property image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                property.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  /// Show placeholder if image fails to load
                  return Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),

            /// Property details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Price and specs row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Price
                      Text(
                        '\$${(property.price / 1000000).toStringAsFixed(1)}M',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),

                      /// Bedrooms and bathrooms
                      Row(
                        children: [
                          _buildSpec(Icons.bed, property.bedrooms.toString()),
                          const SizedBox(width: 12),
                          _buildSpec(
                            Icons.bathroom,
                            property.bathrooms.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a spec badge (bedroom/bathroom count)
  Widget _buildSpec(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds purchase history list
  Widget _buildPurchaseHistory() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _purchaseHistory.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(_purchaseHistory[index]);
      },
    );
  }

  ///  history card
  Widget _buildHistoryCard(Map<String, dynamic> purchase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// rasmi historyaka
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              purchase['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          /// Purchase details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  purchase['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  purchase['location'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${(purchase['price'] / 1000000).toStringAsFixed(1)}M',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),

                    /// box complete'ka
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        purchase['status'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
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
}
