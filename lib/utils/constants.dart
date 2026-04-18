// App constants and configuration
class AppConstants {
  // API endpoints
  static const String baseUrl = '';

  // Default locations (Colombo, Sri Lanka)
  static const double defaultLatitude = 6.9271;
  static const double defaultLongitude = 80.7789;

  // Location radius for nearby reports (in km)
  static const double nearbyRadiusKm = 5.0;

  // Map zoom levels
  static const double defaultMapZoom = 14.0;
  static const double minMapZoom = 3.0;
  static const double maxMapZoom = 19.0;

  // Colors
  static const String primaryColor = '#2196F3';
  static const String successColor = '#4CAF50';
  static const String warningColor = '#FFC107';
  static const String errorColor = '#F44336';

  // Report types
  static const Map<String, String> reportTypes = {
    'blocked_drain': '🚰 Blocked Drain',
    'rising_water': '💧 Rising Water Level',
    'fallen_tree': '🌳 Fallen Tree',
    'flooded_road': '🛣️ Flooded Road',
  };

  // Flood risk levels
  static const Map<String, String> floodRiskLevels = {
    'low': '🟢 Low Risk',
    'medium': '🟡 Medium Risk',
    'high': '🟠 High Risk',
    'critical': '🔴 Critical Risk',
  };

  // App info
  static const String appName = 'FloodGuard Lanka';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Firebase
  static const String firebaseProjectId = 'your-firebase-project';

  // Notification channels
  static const String notificationChannelId = 'flood_alerts';
  static const String notificationChannelName = 'Flood Alerts';
  static const String notificationChannelDescription =
      'Real-time flood alert notifications';

  // Cache durations
  static const Duration cacheReportsDuration = Duration(minutes: 5);
  static const Duration cacheAlertsDuration = Duration(minutes: 10);
}
