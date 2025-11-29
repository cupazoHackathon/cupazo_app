/// User model representing the `users` table
class UserModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final double addressLat;
  final double addressLng;
  final int reliabilityScore;
  final String role;
  final DateTime createdAt;
  final String city;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.addressLat,
    required this.addressLng,
    required this.reliabilityScore,
    required this.role,
    required this.createdAt,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      addressLat: (json['address_lat'] as num).toDouble(),
      addressLng: (json['address_lng'] as num).toDouble(),
      reliabilityScore: json['reliability_score'] as int,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      city: json['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'address_lat': addressLat,
      'address_lng': addressLng,
      'reliability_score': reliabilityScore,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'city': city,
    };
  }
}

