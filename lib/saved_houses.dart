import 'package:flutter/material.dart';
import 'app_style.dart';
import 'details.dart';
import 'firestore_service.dart';
import 'models.dart';

class SavedHousesPage extends StatefulWidget {
  const SavedHousesPage({super.key});

  @override
  State<SavedHousesPage> createState() => _SavedHousesPageState();
}

class _SavedHousesPageState extends State<SavedHousesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      body: StreamBuilder<List<Property>>(
        stream: FirestoreService.savedPropertiesStream(),
        builder: (context, snapshot) {
          final savedHouses = snapshot.data ?? [];
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(savedHouses.length),
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : savedHouses.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 18, 20, 24),
                              itemCount: savedHouses.length,
                              itemBuilder: (context, index) {
                                return _buildSavedCard(savedHouses[index]);
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      decoration: const BoxDecoration(
        color: AppStyle.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saved Houses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count homes saved',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.favorite_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCard(Property property) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
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
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(24),
              ),
              child: Image.network(
                property.image,
                width: 118,
                height: 132,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 118,
                    height: 132,
                    color: Colors.blue.shade50,
                    child: const Icon(
                      Icons.home_work_outlined,
                      color: AppStyle.primary,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            property.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppStyle.text,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            FirestoreService.toggleSavedProperty(
                              propertyId: property.id,
                              currentlySaved: true,
                            );
                          },
                          icon: const Icon(Icons.favorite_rounded),
                          color: AppStyle.danger,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      property.formattedPrice,
                      style: const TextStyle(
                        color: AppStyle.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildMiniSpec(Icons.bed_outlined, '${property.bedrooms}'),
                        const SizedBox(width: 8),
                        _buildMiniSpec(
                          Icons.bathtub_outlined,
                          '${property.bathrooms}',
                        ),
                      ],
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

  Widget _buildMiniSpec(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppStyle.primary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppStyle.primary,
            fontWeight: FontWeight.w800,
          ),
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
              Icons.favorite_border_rounded,
              size: 76,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No saved houses yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on homes you like and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
