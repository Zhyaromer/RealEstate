import 'package:cloud_firestore/cloud_firestore.dart';

/// Property data model
/// Represents a real estate property with all its details
class Property {
  /// Unique identifier for the property
  final String id;

  /// Property title/name
  final String title;

  /// Location (city, state)
  final String location;

  /// Price in dollars
  final double price;

  /// Area in square feet
  final double area;

  /// Number of bedrooms
  final int bedrooms;

  /// Number of bathrooms
  final int bathrooms;

  /// URL of property image
  final String image;

  final List<String> images;

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

  final String ownerId;
  final String ownerEmail;
  final String status;
  final DateTime? createdAt;

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
    this.images = const [],
    required this.description,
    required this.features,
    required this.ownerName,
    required this.ownerPhone,
    required this.propertyType,
    this.ownerId = '',
    this.ownerEmail = '',
    this.status = 'active',
    this.createdAt,
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

  List<String> get galleryImages {
    final savedImages = images
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
    if (savedImages.isNotEmpty) return savedImages;
    return image.trim().isEmpty ? <String>[] : [image.trim()];
  }

  /// Convert Firestore data into a Property object
  factory Property.fromMap(Map<String, dynamic> data, String id) {
    final createdAtValue = data['createdAt'];
    return Property(
      id: id,
      title: data['title']?.toString() ?? 'Unknown Property',
      location: data['location']?.toString() ?? 'Unknown Location',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      area: (data['area'] as num?)?.toDouble() ?? 0.0,
      bedrooms: (data['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (data['bathrooms'] as num?)?.toInt() ?? 0,
      image: data['image']?.toString() ?? '',
      images: List<String>.from(data['images'] ?? <String>[]),
      description: data['description']?.toString() ?? '',
      features: List<String>.from(data['features'] ?? <String>[]),
      ownerName: data['ownerName']?.toString() ?? 'Unknown Owner',
      ownerPhone: data['ownerPhone']?.toString() ?? '',
      propertyType: data['propertyType']?.toString() ?? 'Apartment',
      ownerId: data['ownerId']?.toString() ?? '',
      ownerEmail: data['ownerEmail']?.toString() ?? '',
      status: data['status']?.toString() ?? 'active',
      createdAt: createdAtValue is Timestamp ? createdAtValue.toDate() : null,
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
      'images': images,
      'description': description,
      'features': features,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'propertyType': propertyType,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class RentalProperty {
  final String id;
  final String title;
  final String location;
  final double monthlyRent;
  final double area;
  final int bedrooms;
  final int bathrooms;
  final String image;
  final String furnishing;
  final String availableFrom;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String status;
  final DateTime? createdAt;

  RentalProperty({
    required this.id,
    required this.title,
    required this.location,
    required this.monthlyRent,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.image,
    required this.furnishing,
    required this.availableFrom,
    this.ownerId = '',
    this.ownerName = '',
    this.ownerPhone = '',
    this.status = 'active',
    this.createdAt,
  });

  factory RentalProperty.fromMap(Map<String, dynamic> data, String id) {
    final createdAtValue = data['createdAt'];
    return RentalProperty(
      id: id,
      title: data['title']?.toString() ?? 'Rental Property',
      location: data['location']?.toString() ?? 'Unknown Location',
      monthlyRent: (data['monthlyRent'] as num?)?.toDouble() ?? 0,
      area: (data['area'] as num?)?.toDouble() ?? 0,
      bedrooms: (data['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (data['bathrooms'] as num?)?.toInt() ?? 0,
      image: data['image']?.toString() ?? '',
      furnishing: data['furnishing']?.toString() ?? 'Unfurnished',
      availableFrom: data['availableFrom']?.toString() ?? 'Available Now',
      ownerId: data['ownerId']?.toString() ?? '',
      ownerName: data['ownerName']?.toString() ?? '',
      ownerPhone: data['ownerPhone']?.toString() ?? '',
      status: data['status']?.toString() ?? 'active',
      createdAt: createdAtValue is Timestamp ? createdAtValue.toDate() : null,
    );
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
  final String userId;

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
    this.userId = '',
  });

  factory LoanApplication.fromMap(Map<String, dynamic> data, String id) {
    final submittedAtValue = data['submittedAt'];
    return LoanApplication(
      id: id,
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      employmentType: data['employmentType']?.toString() ?? '',
      monthlyIncome: (data['monthlyIncome'] as num?)?.toDouble() ?? 0,
      loanAmount: (data['loanAmount'] as num?)?.toDouble() ?? 0,
      interestRate: (data['interestRate'] as num?)?.toDouble() ?? 0,
      tenureYears: (data['tenureYears'] as num?)?.toInt() ?? 0,
      monthlyEmi: (data['monthlyEmi'] as num?)?.toDouble() ?? 0,
      status: data['status']?.toString() ?? 'Under Review',
      submittedAt: submittedAtValue is Timestamp
          ? submittedAtValue.toDate()
          : DateTime.now(),
      userId: data['userId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'employmentType': employmentType,
      'monthlyIncome': monthlyIncome,
      'loanAmount': loanAmount,
      'interestRate': interestRate,
      'tenureYears': tenureYears,
      'monthlyEmi': monthlyEmi,
      'status': status,
      'userId': userId,
      'submittedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UserProfile {
  final String username;
  final String email;
  final String phone;

  UserProfile({
    required this.username,
    required this.email,
    required this.phone,
  });
}

class AppStore {
  static UserProfile currentUser = UserProfile(
    username: 'Guest',
    email: 'guest@email.com',
    phone: '+964 750 000 0000',
  );
}
