import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../providers/report_provider.dart';
import '../providers/alert_provider.dart';
import '../models/report_model.dart';
import '../models/alert_model.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  void _initializeLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.requestLocationPermission();
    await locationProvider.getCurrentLocation();

    if (locationProvider.hasLocation) {
      _loadReportsAndAlerts();
    }
  }

  void _loadReportsAndAlerts() {
    final locationProvider = context.read<LocationProvider>();
    final reportProvider = context.read<ReportProvider>();
    final alertProvider = context.read<AlertProvider>();

    if (locationProvider.latitude != null &&
        locationProvider.longitude != null) {
      reportProvider.loadNearbyReports(
        locationProvider.latitude!,
        locationProvider.longitude!,
      );

      alertProvider.loadNearbyAlerts(
        locationProvider.latitude!,
        locationProvider.longitude!,
      );
    }

    _updateMapMarkers();
  }

  void _updateMapMarkers() {
    _markers.clear();
    _circles.clear();

    final locationProvider = context.read<LocationProvider>();
    final reportProvider = context.read<ReportProvider>();
    final alertProvider = context.read<AlertProvider>();

    // Add user location marker
    if (locationProvider.latitude != null &&
        locationProvider.longitude != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            locationProvider.latitude!,
            locationProvider.longitude!,
          ),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      // Add safety circle around user
      _circles.add(
        Circle(
          circleId: const CircleId('safety_circle'),
          center: LatLng(
            locationProvider.latitude!,
            locationProvider.longitude!,
          ),
          radius: 5000, // 5 km
          fillColor: Colors.blue.withOpacity(0.1),
          strokeColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 2,
        ),
      );
    }

    // Add report markers
    for (var report in reportProvider.nearbyReports) {
      _markers.add(
        Marker(
          markerId: MarkerId('report_${report.id}'),
          position: LatLng(report.latitude, report.longitude),
          infoWindow: InfoWindow(
            title: report.reportType.toUpperCase(),
            snippet: report.description,
            onTap: () => _showReportDetails(report),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    // Add alert markers
    for (var alert in alertProvider.nearbyAlerts) {
      final hue = _getRiskLevelHue(alert.riskLevel);
      _markers.add(
        Marker(
          markerId: MarkerId('alert_${alert.id}'),
          position: LatLng(alert.latitude, alert.longitude),
          infoWindow: InfoWindow(
            title: '🚨 ${alert.title}',
            snippet: alert.message,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    }

    setState(() {});
  }

  double _getRiskLevelHue(FloodRiskLevel riskLevel) {
    switch (riskLevel) {
      case FloodRiskLevel.low:
        return BitmapDescriptor.hueGreen;
      case FloodRiskLevel.medium:
        return BitmapDescriptor.hueYellow;
      case FloodRiskLevel.high:
        return BitmapDescriptor.hueOrange;
      case FloodRiskLevel.critical:
        return BitmapDescriptor.hueRed;
    }
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.reportType.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Reported by: ${report.username}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(report.description),
            const SizedBox(height: 16),
            if (report.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  report.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('👍 ${report.upvotes} upvotes'),
                CustomButton(
                  label: '👍 Upvote',
                  width: 100,
                  backgroundColor: Colors.green,
                  onPressed: () {
                    context.read<ReportProvider>().upvoteReport(report.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FloodGuard Lanka'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Consumer<AlertProvider>(
                builder: (context, alertProvider, _) {
                  if (alertProvider.hasHighRiskAlerts) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🚨 Critical Alert',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer4<LocationProvider, ReportProvider, AlertProvider, AuthProvider>(
        builder:
            (
              context,
              locationProvider,
              reportProvider,
              alertProvider,
              authProvider,
              _,
            ) {
              if (!locationProvider.hasLocation) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text('Getting your location...'),
                      const SizedBox(height: 32),
                      CustomButton(
                        label: 'Retry',
                        width: 200,
                        onPressed: _initializeLocation,
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  // Google Map
                  GoogleMap(
                    onMapCreated: (controller) {
                      _updateMapMarkers();
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        locationProvider.latitude!,
                        locationProvider.longitude!,
                      ),
                      zoom: 14,
                    ),
                    markers: _markers,
                    circles: _circles,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),

                  // Bottom cards for quick info
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        // Alerts Card
                        if (alertProvider.nearbyAlerts.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Active Alerts',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        '${alertProvider.nearbyAlerts.length} flood alert(s) near you',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),

                        // Reports Card
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Community Reports',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${reportProvider.nearbyReports.length} report(s) nearby',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/report');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Report'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }
}
