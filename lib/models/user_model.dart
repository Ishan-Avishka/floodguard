class User {
  final String uid;
  final String email;
  final String username;
  final String phoneNumber;
  final double homeLatitude;
  final double homeLongitude;
  final String homeAddress;
  final DateTime createdAt;
  final List<String> savedAlertAreas;

  User({
    required this.uid,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.homeLatitude,
    required this.homeLongitude,
    required this.homeAddress,
    required this.createdAt,
    this.savedAlertAreas = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'homeLatitude': homeLatitude,
      'homeLongitude': homeLongitude,
      'homeAddress': homeAddress,
      'createdAt': createdAt.toIso8601String(),
      'savedAlertAreas': savedAlertAreas,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      homeLatitude: (map['homeLatitude'] ?? 0.0).toDouble(),
      homeLongitude: (map['homeLongitude'] ?? 0.0).toDouble(),
      homeAddress: map['homeAddress'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      savedAlertAreas: List<String>.from(map['savedAlertAreas'] ?? []),
    );
  }

  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? phoneNumber,
    double? homeLatitude,
    double? homeLongitude,
    String? homeAddress,
    DateTime? createdAt,
    List<String>? savedAlertAreas,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeLatitude: homeLatitude ?? this.homeLatitude,
      homeLongitude: homeLongitude ?? this.homeLongitude,
      homeAddress: homeAddress ?? this.homeAddress,
      createdAt: createdAt ?? this.createdAt,
      savedAlertAreas: savedAlertAreas ?? this.savedAlertAreas,
    );
  }
}
