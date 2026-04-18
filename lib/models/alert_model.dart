enum FloodRiskLevel { low, medium, high, critical }

class Alert {
  final String id;
  final String title;
  final String message;
  final double latitude;
  final double longitude;
  final FloodRiskLevel riskLevel;
  final DateTime createdAt;
  final DateTime? expireAt;
  final String area;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.latitude,
    required this.longitude,
    required this.riskLevel,
    required this.createdAt,
    this.expireAt,
    required this.area,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'riskLevel': riskLevel.toString(),
      'createdAt': createdAt.toIso8601String(),
      'expireAt': expireAt?.toIso8601String(),
      'area': area,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      riskLevel: _parseRiskLevel(map['riskLevel']),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      expireAt: map['expireAt'] != null
          ? DateTime.parse(map['expireAt'])
          : null,
      area: map['area'] ?? '',
    );
  }

  static FloodRiskLevel _parseRiskLevel(String? value) {
    if (value == null) return FloodRiskLevel.low;
    switch (value) {
      case 'FloodRiskLevel.low':
        return FloodRiskLevel.low;
      case 'FloodRiskLevel.medium':
        return FloodRiskLevel.medium;
      case 'FloodRiskLevel.high':
        return FloodRiskLevel.high;
      case 'FloodRiskLevel.critical':
        return FloodRiskLevel.critical;
      default:
        return FloodRiskLevel.low;
    }
  }

  String getRiskColor() {
    switch (riskLevel) {
      case FloodRiskLevel.low:
        return '#4CAF50'; // Green
      case FloodRiskLevel.medium:
        return '#FFC107'; // Yellow
      case FloodRiskLevel.high:
        return '#FF9800'; // Orange
      case FloodRiskLevel.critical:
        return '#F44336'; // Red
    }
  }
}
