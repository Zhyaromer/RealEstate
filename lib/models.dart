/// Property data model
/// Represents a real estate property with all its details
class Property {
  /// Unique identifier for the property
  final String id;

  /// Property title/name
  final String title;

  /// Location (city, state)
  final String location;

  /// Price in rupees
  final double price;

  /// Area in square feet
  final double area;

  /// Number of bedrooms
  final int bedrooms;

  /// Number of bathrooms
  final int bathrooms;

  /// URL of property image
  final String image;

  /// Detailed description
  final String description;

  /// List of amenities/features
  final List<String> features;

  /// Property owner's name
  final String ownerName;

  /// Property owner's phone number
  final String ownerPhone;

  /// Property type
  final String propertyType;

  /// Constructor - Creates a new Property instance
  /// All fields are required
  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.image,
    required this.description,
    required this.features,
    required this.ownerName,
    required this.ownerPhone,
    required this.propertyType,
  });

  /// Formats price to display in millions with 1 decimal place
  /// Example: 5000000 -> "5.0M"
  String get formattedPrice {
    return '\$${(price / 1000000).toStringAsFixed(1)}M';
  }

  /// Formats area with comma separator
  /// Example: 3500 -> "3,500 sq.ft"
  String get formattedArea {
    return '${area.toInt()} sq.ft';
  }

  /// Convert Firestore data into a Property object
  factory Property.fromMap(Map<String, dynamic> data, String id) {
    return Property(
      id: id,
      title: data['title']?.toString() ?? 'Unknown Property',
      location: data['location']?.toString() ?? 'Unknown Location',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      area: (data['area'] as num?)?.toDouble() ?? 0.0,
      bedrooms: (data['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (data['bathrooms'] as num?)?.toInt() ?? 0,
      image: data['image']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      features: List<String>.from(data['features'] ?? <String>[]),
      ownerName: data['ownerName']?.toString() ?? 'Unknown Owner',
      ownerPhone: data['ownerPhone']?.toString() ?? '',
      propertyType: data['propertyType']?.toString() ?? 'Apartment',
    );
  }

  /// Convert Property object to data map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'price': price,
      'area': area,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'image': image,
      'description': description,
      'features': features,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'propertyType': propertyType,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
