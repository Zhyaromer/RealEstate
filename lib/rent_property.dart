import 'package:flutter/material.dart';
import 'app_style.dart';
import 'firestore_service.dart';
import 'models.dart';

/// Rent Property Page
/// Shows list of properties available for rent
class RentPropertyPage extends StatefulWidget {
  const RentPropertyPage({super.key});

  @override
  State<RentPropertyPage> createState() => _RentPropertyPageState();
}

class _RentPropertyPageState extends State<RentPropertyPage> {
  /// Filter selections
  String _selectedFurnishing = 'All';

  List<RentalProperty> _rentalProperties = [];

  /// filter
  List<RentalProperty> get _filteredProperties {
    if (_selectedFurnishing == 'All') {
      return _rentalProperties;
    }
    return _rentalProperties
        .where((property) => property.furnishing == _selectedFurnishing)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: StreamBuilder<List<RentalProperty>>(
        stream: FirestoreService.rentalPropertiesStream(),
        builder: (context, snapshot) {
          _rentalProperties = snapshot.data ?? [];
          return Container(
            color: AppStyle.primaryDark,
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFilters(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                        color: AppStyle.background,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredProperties.isEmpty
                              ? _buildEmptyState()
                              : _buildPropertiesList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds page header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              //title page
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rent Property',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Find your perfect rental',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// filterakan
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Fully Furnished'),
          const SizedBox(width: 8),
          _buildFilterChip('Semi Furnished'),
          const SizedBox(width: 8),
          _buildFilterChip('Unfurnished'),
        ],
      ),
    );
  }

  /// nwsini aw filteraka
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFurnishing == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFurnishing = label);
      },
      backgroundColor: Colors.white.withOpacity(0.2),
      selectedColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected
            ? const Color.fromARGB(255, 21, 101, 192)
            : const Color.fromARGB(255, 21, 101, 192).withOpacity(0.7),
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
    );
  }

  /// agar batall be wak (unfurnished)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds list of rental properties
  Widget _buildPropertiesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filteredProperties.length,
      itemBuilder: (context, index) {
        return _buildPropertyCard(_filteredProperties[index]);
      },
    );
  }

  /// Bbashi xwaraway list cardaka
  Widget _buildPropertyCard(RentalProperty property) {
    return GestureDetector(
      onTap: () => _showPropertyDetails(property),
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
            /// Property image with furnishing badge
            Stack(
              children: [
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
                      return Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),

                /// nwsini sar rasmi cardaka
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppStyle.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      property.furnishing,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// zanyariakani xanwaka
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Monthly rent
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${property.monthlyRent.toInt()}/mo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppStyle.primary,
                            ),
                          ),
                          Text(
                            'Available: ${property.availableFrom}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      /// Specs
                      Row(
                        children: [
                          _buildSpec(Icons.bed, property.bedrooms.toString()),
                          const SizedBox(width: 8),
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

  /// logo bchwkakani 3adadai zhwrakan
  Widget _buildSpec(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppStyle.primary),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppStyle.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// lagal click krdnaway cardaka zanyariakan pishan ayat
  void _showPropertyDetails(RentalProperty property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            /// Handle bar
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red.shade400),
                        const SizedBox(width: 8),
                        Text(
                          property.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Monthly rent
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Rent',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${property.monthlyRent.toInt()}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppStyle.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// zanyari dway click krdn ka pishan adret
                    _buildDetailRow('Furnishing', property.furnishing),
                    _buildDetailRow('Available From', property.availableFrom),
                    _buildDetailRow('Area', '${property.area.toInt()} sq.ft'),
                    _buildDetailRow('Bedrooms', '${property.bedrooms}'),
                    _buildDetailRow('Bathrooms', '${property.bathrooms}'),
                    const SizedBox(height: 24),

                    /// button contact
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contact request sent!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Contact Owner'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
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

  /// Builds detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
