/// Match group member model representing the `match_group_members` table
class MatchGroupMemberModel {
  final String id;
  final String groupId;
  final String userId;
  final String role;
  final DateTime joinedAt;
  final String? deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;
  final String status;

  MatchGroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    required this.status,
  });

  factory MatchGroupMemberModel.fromJson(Map<String, dynamic> json) {
    return MatchGroupMemberModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      deliveryAddress: json['delivery_address'] as String?,
      deliveryLat: json['delivery_lat'] != null
          ? (json['delivery_lat'] as num).toDouble()
          : null,
      deliveryLng: json['delivery_lng'] != null
          ? (json['delivery_lng'] as num).toDouble()
          : null,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'user_id': userId,
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
      'delivery_address': deliveryAddress,
      'delivery_lat': deliveryLat,
      'delivery_lng': deliveryLng,
      'status': status,
    };
  }
}

