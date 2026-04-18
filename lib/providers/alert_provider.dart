import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/firestore_service.dart';

class AlertProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Alert> _nearbyAlerts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Alert> get nearbyAlerts => _nearbyAlerts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasHighRiskAlerts =>
      _nearbyAlerts.any((alert) => alert.riskLevel == FloodRiskLevel.critical);
  bool get hasMediumRiskAlerts => _nearbyAlerts.any(
    (alert) =>
        alert.riskLevel == FloodRiskLevel.high ||
        alert.riskLevel == FloodRiskLevel.medium,
  );

  Future<void> loadNearbyAlerts(
    double latitude,
    double longitude, {
    double radiusInKm = 10.0,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _nearbyAlerts = await _firestoreService.getAlertsNearby(
        latitude,
        longitude,
        radiusInKm,
      );
      _nearbyAlerts.sort((a, b) {
        // Sort by risk level (high first) then by date
        final riskOrder = {
          FloodRiskLevel.critical: 0,
          FloodRiskLevel.high: 1,
          FloodRiskLevel.medium: 2,
          FloodRiskLevel.low: 3,
        };
        final riskCompare = (riskOrder[a.riskLevel] ?? 4).compareTo(
          riskOrder[b.riskLevel] ?? 4,
        );
        if (riskCompare != 0) return riskCompare;
        return b.createdAt.compareTo(a.createdAt);
      });
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAlert({
    required String title,
    required String message,
    required double latitude,
    required double longitude,
    required FloodRiskLevel riskLevel,
    required String area,
  }) async {
    try {
      await _firestoreService.createAlert(
        title: title,
        message: message,
        latitude: latitude,
        longitude: longitude,
        riskLevel: riskLevel,
        area: area,
      );
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
