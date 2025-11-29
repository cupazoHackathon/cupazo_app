/// Deal interest model representing the `deal_interests` table
class DealInterestModel {
  final String id;
  final String dealId;
  final String userId;
  final String status;
  final String preferredTimeWindow;
  final DateTime createdAt;

  DealInterestModel({
    required this.id,
    required this.dealId,
    required this.userId,
    required this.status,
    required this.preferredTimeWindow,
    required this.createdAt,
  });

  factory DealInterestModel.fromJson(Map<String, dynamic> json) {
    return DealInterestModel(
      id: json['id'] as String,
      dealId: json['deal_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      preferredTimeWindow: json['preferred_time_window'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deal_id': dealId,
      'user_id': userId,
      'status': status,
      'preferred_time_window': preferredTimeWindow,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

