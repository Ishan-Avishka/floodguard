import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:math';
import '../models/report_model.dart';
import '../models/alert_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Reports
  Future<String> createReport({
    required String userId,
    required String username,
    required String reportType,
    required String description,
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile, userId);
      }

      final reportId = _db.collection('reports').doc().id;
      final report = Report(
        id: reportId,
        userId: userId,
        username: username,
        reportType: reportType,
        description: description,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _db.collection('reports').doc(reportId).set(report.toMap());
      return reportId;
    } catch (e) {
      throw Exception('Failed to create report: $e');
    }
  }

  Future<List<Report>> getReportsNearby(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      final snapshot = await _db.collection('reports').get();
      final reports = snapshot.docs
          .map((doc) => Report.fromMap(doc.data()))
          .toList();

      // Filter reports within radius
      return reports.where((report) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          report.latitude,
          report.longitude,
        );
        return distance <= radiusInKm;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get nearby reports: $e');
    }
  }

  Future<List<Report>> getAllReports() async {
    try {
      final snapshot = await _db
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Report.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get reports: $e');
    }
  }

  Future<void> upvoteReport(String reportId) async {
    try {
      await _db.collection('reports').doc(reportId).update({
        'upvotes': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to upvote report: $e');
    }
  }

  // Alerts
  Future<void> createAlert({
    required String title,
    required String message,
    required double latitude,
    required double longitude,
    required FloodRiskLevel riskLevel,
    required String area,
  }) async {
    try {
      final alertId = _db.collection('alerts').doc().id;
      final alert = Alert(
        id: alertId,
        title: title,
        message: message,
        latitude: latitude,
        longitude: longitude,
        riskLevel: riskLevel,
        createdAt: DateTime.now(),
        expireAt: DateTime.now().add(Duration(hours: 6)),
        area: area,
      );

      await _db.collection('alerts').doc(alertId).set(alert.toMap());
    } catch (e) {
      throw Exception('Failed to create alert: $e');
    }
  }

  Future<List<Alert>> getAlertsNearby(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      final snapshot = await _db
          .collection('alerts')
          .where('expireAt', isGreaterThan: Timestamp.now())
          .get();

      final alerts = snapshot.docs
          .map((doc) => Alert.fromMap(doc.data()))
          .toList();

      return alerts.where((alert) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          alert.latitude,
          alert.longitude,
        );
        return distance <= radiusInKm;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get nearby alerts: $e');
    }
  }

  // Image Upload
  Future<String> _uploadImage(File imageFile, String userId) async {
    try {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('reports').child(fileName);

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Helper method to calculate distance between two coordinates (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}
