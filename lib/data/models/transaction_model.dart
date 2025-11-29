/// Transaction model representing the `transactions` table
class TransactionModel {
  final String id;
  final String matchGroupId;
  final String payerUserId;
  final double amountTotal;
  final double platformFee;
  final double deliveryFee;
  final String paymentStatus;
  final String? stripePaymentId;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.matchGroupId,
    required this.payerUserId,
    required this.amountTotal,
    required this.platformFee,
    required this.deliveryFee,
    required this.paymentStatus,
    this.stripePaymentId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      matchGroupId: json['match_group_id'] as String,
      payerUserId: json['payer_user_id'] as String,
      amountTotal: (json['amount_total'] as num).toDouble(),
      platformFee: (json['platform_fee'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String,
      stripePaymentId: json['stripe_payment_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_group_id': matchGroupId,
      'payer_user_id': payerUserId,
      'amount_total': amountTotal,
      'platform_fee': platformFee,
      'delivery_fee': deliveryFee,
      'payment_status': paymentStatus,
      'stripe_payment_id': stripePaymentId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

