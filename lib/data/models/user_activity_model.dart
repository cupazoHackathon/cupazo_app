/// User activity model representing the `user_activity` table
class UserActivityModel {
  final String id;
  final String userId;
  final String? dealId;
  final String eventType;
  final String? source;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  UserActivityModel({
    required this.id,
    required this.userId,
    this.dealId,
    required this.eventType,
    this.source,
    this.metadata,
    required this.createdAt,
  });

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    return UserActivityModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      dealId: json['deal_id'] as String?,
      eventType: json['event_type'] as String,
      source: json['source'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'deal_id': dealId,
      'event_type': eventType,
      'source': source,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

