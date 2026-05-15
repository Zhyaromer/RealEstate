import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static User? get currentUser => _auth.currentUser;

  static Future<void> signUp({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Unable to create your account. Please try again.',
      );
    }

    await user.updateDisplayName(username);
    await user.sendEmailVerification();

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'username': username,
      'email': email,
      'phone': phone,
      'emailVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    AppStore.currentUser = UserProfile(
      username: username,
      email: email,
      phone: phone,
    );
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Unable to sign in. Please try again.',
      );
    }

    await user.reload();
    final refreshedUser = _auth.currentUser;
    if (refreshedUser == null || !refreshedUser.emailVerified) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before signing in.',
      );
    }

    await _markEmailVerified(refreshedUser.uid);
    await loadCurrentUserProfile();
  }

  static Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    await user.reload();
    final refreshedUser = _auth.currentUser;
    final verified = refreshedUser?.emailVerified ?? false;
    if (verified && refreshedUser != null) {
      await _markEmailVerified(refreshedUser.uid);
      await loadCurrentUserProfile();
    }
    return verified;
  }

  static Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Please sign up or sign in again first.',
      );
    }
    await user.sendEmailVerification();
  }

  static Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> loadCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    final data = snapshot.data();

    AppStore.currentUser = UserProfile(
      username:
          data?['username']?.toString() ?? user.displayName ?? 'User',
      email: data?['email']?.toString() ?? user.email ?? '',
      phone: data?['phone']?.toString() ?? '',
    );
  }

  static Future<void> signOut() {
    AppStore.currentUser = UserProfile(
      username: 'Guest',
      email: 'guest@email.com',
      phone: '+964 750 000 0000',
    );
    return _auth.signOut();
  }

  static String friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-email' => 'Please enter a valid email.',
        'user-not-found' => 'No account found with this email.',
        'wrong-password' => 'Incorrect password.',
        'invalid-credential' => 'Email or password is incorrect.',
        'email-already-in-use' => 'This email is already registered.',
        'weak-password' => 'Password is too weak.',
        'email-not-verified' =>
          error.message ?? 'Please verify your email before signing in.',
        'network-request-failed' => 'Network error. Check your connection.',
        _ => error.message ?? 'Something went wrong. Please try again.',
      };
    }
    return 'Something went wrong. Please try again.';
  }

  static Future<void> _markEmailVerified(String uid) {
    return _firestore.collection('users').doc(uid).set({
      'emailVerified': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
