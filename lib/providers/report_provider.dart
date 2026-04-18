import 'package:flutter/material.dart';
import 'dart:io';
import '../models/report_model.dart';
import '../services/firestore_service.dart';

class ReportProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Report> _nearbyReports = [];
  List<Report> _allReports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Report> get nearbyReports => _nearbyReports;
  List<Report> get allReports => _allReports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<String?> createReport({
    required String userId,
    required String username,
    required String reportType,
    required String description,
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reportId = await _firestoreService.createReport(
        userId: userId,
        username: username,
        reportType: reportType,
        description: description,
        latitude: latitude,
        longitude: longitude,
        imageFile: imageFile,
      );
      await loadNearbyReports(latitude, longitude);
      return reportId;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNearbyReports(
    double latitude,
    double longitude, {
    double radiusInKm = 5.0,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _nearbyReports = await _firestoreService.getReportsNearby(
        latitude,
        longitude,
        radiusInKm,
      );
      _nearbyReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allReports = await _firestoreService.getAllReports();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> upvoteReport(String reportId) async {
    try {
      await _firestoreService.upvoteReport(reportId);
      // Reload reports
      if (_nearbyReports.isNotEmpty) {
        await loadNearbyReports(
          _nearbyReports.first.latitude,
          _nearbyReports.first.longitude,
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
