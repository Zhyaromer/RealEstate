import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _imgbbApiKey = 'a28c23a38f3fe4faccad873c1aaef746';

  static User get _user {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Please sign in first.',
      );
    }
    return user;
  }

  static Future<Map<String, String>> _currentProfileData() async {
    final user = _user;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data() ?? {};
    return {
      'username': data['username']?.toString() ??
          user.displayName ??
          user.email ??
          'Property Owner',
      'phone': data['phone']?.toString() ?? '',
      'email': user.email ?? data['email']?.toString() ?? '',
    };
  }

  static Future<void> _assertOwnProperty(String propertyId) async {
    final user = _user;
    final doc = await _firestore.collection('properties').doc(propertyId).get();
    final data = doc.data();
    if (!doc.exists || data == null) {
      throw FirebaseAuthException(
        code: 'not-found',
        message: 'This property no longer exists.',
      );
    }
    if (data['ownerId']?.toString() != user.uid) {
      throw FirebaseAuthException(
        code: 'permission-denied',
        message: 'You can only manage your own properties.',
      );
    }
  }

  static Future<void> _assertAdmin() async {
    final doc = await _firestore.collection('users').doc(_user.uid).get();
    final role = doc.data()?['role']?.toString().trim().toLowerCase();
    if (role != 'admin') {
      throw FirebaseAuthException(
        code: 'permission-denied',
        message: 'Admin access is required.',
      );
    }
  }

  static Stream<List<Property>> propertiesStream() {
    return _firestore
        .collection('properties')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      final properties = snapshot.docs
          .map((doc) => Property.fromMap(doc.data(), doc.id))
          .toList();
      properties.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return properties;
    });
  }

  static Stream<List<Property>> myPropertiesStream() {
    return _firestore
        .collection('properties')
        .where('ownerId', isEqualTo: _user.uid)
        .snapshots()
        .map((snapshot) {
      final properties = snapshot.docs
          .map((doc) => Property.fromMap(doc.data(), doc.id))
          .where((property) => property.status != 'deleted')
          .toList();
      properties.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return properties;
    });
  }

  static Future<void> addProperty(Property property) async {
    final user = _user;
    final profile = await _currentProfileData();
    final data = property.toMap()
      ..['ownerId'] = user.uid
      ..['ownerEmail'] = profile['email'] ?? ''
      ..['ownerName'] = profile['username'] ?? 'Property Owner'
      ..['ownerPhone'] = profile['phone'] ?? ''
      ..['status'] = 'pending'
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('properties').add(data);
  }

  static Future<String?> uploadImageToImgBB(Uint8List imageBytes) async {
    final response = await http.post(
      Uri.parse('https://api.imgbb.com/1/upload?key=$_imgbbApiKey'),
      body: {
        'image': base64Encode(imageBytes),
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;
    return data?['url']?.toString();
  }

  static Future<List<String>> uploadImagesToImgBB(
    List<Uint8List> imageBytesList,
  ) async {
    final urls = <String>[];
    for (final imageBytes in imageBytesList) {
      final url = await uploadImageToImgBB(imageBytes);
      if (url != null && url.isNotEmpty) {
        urls.add(url);
      }
    }
    return urls;
  }

  static Future<void> updateProperty(Property property) async {
    final user = _user;
    await _assertOwnProperty(property.id);
    final profile = await _currentProfileData();

    return _firestore.collection('properties').doc(property.id).update({
      ...property.toMap(),
      'ownerId': user.uid,
      'ownerEmail': profile['email'] ?? property.ownerEmail,
      'ownerName': profile['username'] ?? property.ownerName,
      'ownerPhone': profile['phone'] ?? property.ownerPhone,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<RentalProperty>> rentalPropertiesStream() {
    return _firestore
        .collection('rentals')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      final rentals = snapshot.docs
          .map((doc) => RentalProperty.fromMap(doc.data(), doc.id))
          .toList();
      rentals.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return rentals;
    });
  }

  static Stream<List<Property>> adminPropertiesStream() {
    return _firestore.collection('properties').snapshots().map((snapshot) {
      final properties = snapshot.docs
          .map((doc) => Property.fromMap(doc.data(), doc.id))
          .where((property) => property.status != 'deleted')
          .toList();
      properties.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return properties;
    });
  }

  static Stream<List<Property>> pendingPropertiesStream() {
    return _firestore
        .collection('properties')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final properties = snapshot.docs
          .map((doc) => Property.fromMap(doc.data(), doc.id))
          .toList();
      properties.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return properties;
    });
  }

  static Stream<List<RentalProperty>> adminRentalsStream() {
    return _firestore.collection('rentals').snapshots().map((snapshot) {
      final rentals = snapshot.docs
          .map((doc) => RentalProperty.fromMap(doc.data(), doc.id))
          .where((rental) => rental.status != 'deleted')
          .toList();
      rentals.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return rentals;
    });
  }

  static Stream<List<UserProfile>> adminUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      final users = snapshot.docs
          .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
          .toList();
      users.sort((a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()));
      return users;
    });
  }

  static Future<void> adminAddProperty(Property property) async {
    await _assertAdmin();
    final data = property.toMap()
      ..['status'] = property.status
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('properties').add(data);
  }

  static Future<void> adminUpdateProperty(Property property) async {
    await _assertAdmin();
    await _firestore.collection('properties').doc(property.id).update({
      ...property.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> adminDeleteProperty(String propertyId) async {
    await _assertAdmin();
    await _firestore.collection('properties').doc(propertyId).delete();
  }

  static Future<void> adminSetPropertyStatus(String propertyId, String status) async {
    await _assertAdmin();
    await _firestore.collection('properties').doc(propertyId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> adminAddRental(RentalProperty rental) async {
    await _assertAdmin();
    final data = rental.toMap()
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('rentals').add(data);
  }

  static Future<void> adminUpdateRental(RentalProperty rental) async {
    await _assertAdmin();
    await _firestore.collection('rentals').doc(rental.id).update({
      ...rental.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> adminDeleteRental(String rentalId) async {
    await _assertAdmin();
    await _firestore.collection('rentals').doc(rentalId).delete();
  }

  static Future<void> adminUpsertUser(UserProfile profile) async {
    await _assertAdmin();
    final ref = profile.uid.trim().isEmpty
        ? _firestore.collection('users').doc()
        : _firestore.collection('users').doc(profile.uid);
    await ref.set({
      ...profile.toMap(),
      'uid': ref.id,
      'role': profile.role == 'admin' ? 'admin' : 'user',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> adminDeleteUser(String uid) async {
    await _assertAdmin();
    if (uid == _user.uid) {
      throw FirebaseAuthException(
        code: 'permission-denied',
        message: 'You cannot delete your own admin profile while signed in.',
      );
    }
    await _firestore.collection('users').doc(uid).delete();
  }

  static Future<void> deleteProperty(Property property) async {
    await _assertOwnProperty(property.id);
    return _firestore.collection('properties').doc(property.id).delete();
  }

  static Stream<Set<String>> savedPropertyIdsStream() {
    return _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('savedProperties')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  static Stream<List<Property>> savedPropertiesStream() {
    return savedPropertyIdsStream().asyncMap((ids) async {
      if (ids.isEmpty) return <Property>[];
      final properties = <Property>[];
      for (final id in ids) {
        final doc = await _firestore.collection('properties').doc(id).get();
        final data = doc.data();
        if (doc.exists && data != null && data['status'] == 'active') {
          properties.add(Property.fromMap(data, doc.id));
        }
      }
      return properties;
    });
  }

  static Future<void> toggleSavedProperty({
    required String propertyId,
    required bool currentlySaved,
  }) {
    final ref = _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('savedProperties')
        .doc(propertyId);

    if (currentlySaved) {
      return ref.delete();
    }

    return ref.set({
      'propertyId': propertyId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<LoanApplication>> loanApplicationsStream() {
    return _firestore
        .collection('loanApplications')
        .where('userId', isEqualTo: _user.uid)
        .snapshots()
        .map((snapshot) {
      final applications = snapshot.docs
          .map((doc) => LoanApplication.fromMap(doc.data(), doc.id))
          .toList();
      applications.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
      return applications;
    });
  }

  static Future<void> addLoanApplication(LoanApplication application) async {
    final user = _user;
    final data = application.toMap()
      ..['userId'] = user.uid
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('loanApplications').add(data);
  }

  static Stream<List<Map<String, dynamic>>> purchaseHistoryStream() {
    return _firestore
        .collection('purchases')
        .where('buyerId', isEqualTo: _user.uid)
        .snapshots()
        .map((snapshot) {
      final purchases = snapshot.docs.map((doc) {
        final data = doc.data();
        final purchasedAt = data['purchasedAt'];
        return {
          ...data,
          'id': doc.id,
          'purchasedDate': purchasedAt is Timestamp
              ? purchasedAt.toDate()
              : DateTime.now(),
        };
      }).toList();
      purchases.sort((a, b) {
        final aDate = a['purchasedDate'] as DateTime;
        final bDate = b['purchasedDate'] as DateTime;
        return bDate.compareTo(aDate);
      });
      return purchases;
    });
  }

  static Future<void> addPurchase(Property property) async {
    final user = _user;
    await _firestore.collection('purchases').add({
      'buyerId': user.uid,
      'buyerEmail': user.email ?? '',
      'propertyId': property.id,
      'title': property.title,
      'location': property.location,
      'price': property.price,
      'image': property.image,
      'ownerId': property.ownerId,
      'ownerName': property.ownerName,
      'ownerPhone': property.ownerPhone,
      'status': 'Completed',
      'purchasedAt': FieldValue.serverTimestamp(),
    });
  }
}
