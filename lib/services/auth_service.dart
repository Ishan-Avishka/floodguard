import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart' as user_model;

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<user_model.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      final userData = await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (userData.exists) {
        return user_model.User.fromMap({
          'uid': firebaseUser.uid,
          ...userData.data()!,
        });
      }
      return null;
    });
  }

  Future<user_model.User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    final userData = await _db.collection('users').doc(firebaseUser.uid).get();
    if (userData.exists) {
      return user_model.User.fromMap({
        'uid': firebaseUser.uid,
        ...userData.data()!,
      });
    }
    return null;
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = user_model.User(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        phoneNumber: phoneNumber,
        homeLatitude: 0.0,
        homeLongitude: 0.0,
        homeAddress: '',
        createdAt: DateTime.now(),
      );

      await _db
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    String? phoneNumber,
    double? homeLatitude,
    double? homeLongitude,
    String? homeAddress,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (homeLatitude != null) updateData['homeLatitude'] = homeLatitude;
      if (homeLongitude != null) updateData['homeLongitude'] = homeLongitude;
      if (homeAddress != null) updateData['homeAddress'] = homeAddress;

      await _db.collection('users').doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }
}
