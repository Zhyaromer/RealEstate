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

class LoanApplication {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String employmentType;
  final double monthlyIncome;
  final double loanAmount;
  final double interestRate;
  final int tenureYears;
  final double monthlyEmi;
  final String status;
  final DateTime submittedAt;

  LoanApplication({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.employmentType,
    required this.monthlyIncome,
    required this.loanAmount,
    required this.interestRate,
    required this.tenureYears,
    required this.monthlyEmi,
    required this.status,
    required this.submittedAt,
  });
}

class AppStore {
  static final List<Property> myProperties = [
    Property(
      id: 'mine-1',
      title: 'Sunny Family House',
      location: 'Erbil, Kurdistan',
      price: 420000,
      area: 2400,
      bedrooms: 4,
      bathrooms: 3,
      image:
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=900',
      description: 'Bright family home with a private garden and parking.',
      features: ['Garden', 'Parking', 'Balcony', 'Security'],
      ownerName: 'Guest',
      ownerPhone: '+964 750 000 0000',
      propertyType: 'House',
    ),
    Property(
      id: 'mine-2',
      title: 'City View Apartment',
      location: 'Sulaymaniyah, Kurdistan',
      price: 185000,
      area: 1250,
      bedrooms: 2,
      bathrooms: 2,
      image:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900',
      description: 'Modern apartment close to cafes, shops, and main roads.',
      features: ['Lift', 'Parking', 'City View'],
      ownerName: 'Guest',
      ownerPhone: '+964 750 000 0000',
      propertyType: 'Apartment',
    ),
  ];

  static final List<LoanApplication> loanApplications = [
    LoanApplication(
      id: 'loan-1',
      name: 'Guest User',
      email: 'guest@email.com',
      phone: '+964 750 000 0000',
      employmentType: 'Salaried',
      monthlyIncome: 2500,
      loanAmount: 180000,
      interestRate: 8.5,
      tenureYears: 20,
      monthlyEmi: 1562,
      status: 'Under Review',
      submittedAt: DateTime(2026, 5, 10),
    ),
  ];
}
