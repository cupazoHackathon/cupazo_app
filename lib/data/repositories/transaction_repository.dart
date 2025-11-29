import '../models/transaction_model.dart';
import '../../services/supabase_service.dart';

/// Repository for transaction-related database operations
class TransactionRepository {
  final _supabase = SupabaseService.client;

  /// Create a new transaction
  Future<TransactionModel> createTransaction({
    required String matchGroupId,
    required String payerUserId,
    required double amountTotal,
    required double platformFee,
    required double deliveryFee,
    required String paymentStatus,
    String? stripePaymentId,
  }) async {
    try {
      final response = await _supabase
          .from('transactions')
          .insert({
            'match_group_id': matchGroupId,
            'payer_user_id': payerUserId,
            'amount_total': amountTotal,
            'platform_fee': platformFee,
            'delivery_fee': deliveryFee,
            'payment_status': paymentStatus,
            'stripe_payment_id': stripePaymentId,
          })
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Error creating transaction: $e');
    }
  }

  /// Get all transactions for a user (as payer)
  Future<List<TransactionModel>> getTransactionsForUser(String userId) async {
    try {
      final response = await _supabase
          .from('transactions')
          .select()
          .eq('payer_user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) =>
              TransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching transactions for user: $e');
    }
  }
}

// Example usage:
// final transactionRepo = TransactionRepository();
// final transaction = await transactionRepo.createTransaction(
//   matchGroupId: 'group-uuid',
//   payerUserId: 'user-uuid',
//   amountTotal: 50.0,
//   platformFee: 2.5,
//   deliveryFee: 5.0,
//   paymentStatus: 'pending',
//   stripePaymentId: 'stripe-id',
// );
// final transactions = await transactionRepo.getTransactionsForUser('user-uuid');

