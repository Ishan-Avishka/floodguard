import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/location_provider.dart';
import '../providers/report_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_widgets.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  String _selectedReportType = 'blocked_drain';
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> _reportTypes = [
    {'value': 'blocked_drain', 'label': '🚰 Blocked Drain', 'icon': '🚰'},
    {'value': 'rising_water', 'label': '💧 Rising Water Level', 'icon': '💧'},
    {'value': 'fallen_tree', 'label': '🌳 Fallen Tree', 'icon': '🌳'},
    {'value': 'flooded_road', 'label': '🛣️ Flooded Road', 'icon': '🛣️'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  void _initializeLocation() async {
    final locationProvider = context.read<LocationProvider>();
    if (!locationProvider.hasLocation) {
      await locationProvider.getCurrentLocation();
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (!context.mounted) return;

      final locationProvider = context.read<LocationProvider>();
      final reportProvider = context.read<ReportProvider>();
      final authProvider = context.read<AuthProvider>();

      if (!locationProvider.hasLocation) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location to submit a report'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final result = await reportProvider.createReport(
        userId: authProvider.currentUser?.uid ?? '',
        username: authProvider.currentUser?.username ?? 'Anonymous',
        reportType: _selectedReportType,
        description: _descriptionController.text.trim(),
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
        imageFile: _selectedImage,
      );

      if (!mounted) return;

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Report submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form
        _descriptionController.clear();
        setState(() {
          _selectedImage = null;
          _selectedReportType = 'blocked_drain';
        });

        // Return to home after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              reportProvider.errorMessage ?? 'Failed to submit report',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report a Problem'), elevation: 0),
      body: Consumer2<LocationProvider, ReportProvider>(
        builder: (context, locationProvider, reportProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Report Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                locationProvider.hasLocation
                                    ? '📍 ${locationProvider.latitude?.toStringAsFixed(4)}, ${locationProvider.longitude?.toStringAsFixed(4)}'
                                    : 'Getting location...',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Report Type Selection
                  const Text(
                    'What\'s the problem?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: _reportTypes.length,
                    itemBuilder: (context, index) {
                      final reportType = _reportTypes[index];
                      final isSelected =
                          _selectedReportType == reportType['value'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedReportType = reportType['value']!;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade100
                                : Colors.grey.shade100,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                reportType['icon']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reportType['label']!.split(' ')[0],
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (reportType['label']!.split(' ').length > 1)
                                Text(
                                  reportType['label']!.split(' ')[1],
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 10,
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please describe the problem';
                      }
                      if (value!.length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Describe the problem in detail (e.g., "Drain is completely blocked with trash")',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Photo Section
                  const Text(
                    'Add a Photo (Optional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickImageFromGallery,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.blue,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'From Gallery',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),

                  // Submit Button
                  CustomButton(
                    label: 'Submit Report',
                    isLoading: reportProvider.isLoading,
                    backgroundColor: Colors.green,
                    onPressed: _submitReport,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
