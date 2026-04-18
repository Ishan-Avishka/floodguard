import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  double? _latitude;
  double? _longitude;
  String? _address;
  bool _isLoading = false;
  String? _errorMessage;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get address => _address;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _latitude != null && _longitude != null;

  Future<void> requestLocationPermission() async {
    try {
      final hasPermission = await _locationService.requestLocationPermission();
      if (!hasPermission) {
        _errorMessage = 'Location permission denied';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocationFromAddress(String address) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final coordinates = await _locationService.getCoordinatesFromAddress(
        address,
      );
      if (coordinates != null) {
        _latitude = coordinates['latitude'];
        _longitude = coordinates['longitude'];
        _address = address;
      } else {
        _errorMessage = 'Could not find location for address';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  double? getDistanceTo(double latitude, double longitude) {
    if (_latitude == null || _longitude == null) return null;
    return _locationService.calculateDistance(
      _latitude!,
      _longitude!,
      latitude,
      longitude,
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
