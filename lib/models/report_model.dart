class Report {
  final String id;
  final String userId;
  final String username;
  final String
  reportType; // blocked_drain, rising_water, fallen_tree, flooded_road
  final String description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime createdAt;
  final int upvotes;
  final bool resolved;

  Report({
    required this.id,
    required this.userId,
    required this.username,
    required this.reportType,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.createdAt,
    this.upvotes = 0,
    this.resolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'reportType': reportType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'upvotes': upvotes,
      'resolved': resolved,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      reportType: map['reportType'] ?? 'other',
      description: map['description'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      upvotes: map['upvotes'] ?? 0,
      resolved: map['resolved'] ?? false,
    );
  }

  Report copyWith({
    String? id,
    String? userId,
    String? username,
    String? reportType,
    String? description,
    double? latitude,
    double? longitude,
    String? imageUrl,
    DateTime? createdAt,
    int? upvotes,
    bool? resolved,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      reportType: reportType ?? this.reportType,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      resolved: resolved ?? this.resolved,
    );
  }
}
