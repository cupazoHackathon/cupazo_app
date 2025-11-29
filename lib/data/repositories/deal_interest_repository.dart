import '../models/deal_interest_model.dart';
import '../../services/supabase_service.dart';

/// Repository for deal interest-related database operations
class DealInterestRepository {
  final _supabase = SupabaseService.client;

  /// Add interest for a deal
  Future<void> addInterest({
    required String dealId,
    required String userId,
    required String status,
  }) async {
    try {
      await _supabase.from('deal_interests').insert({
        'deal_id': dealId,
        'user_id': userId,
        'status': status,
        'preferred_time_window': '',
      });
    } catch (e) {
      throw Exception('Error adding deal interest: $e');
    }
  }

  /// Get all interests for a user
  Future<List<DealInterestModel>> getInterestsForUser(String userId) async {
    try {
      final response = await _supabase
          .from('deal_interests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) =>
              DealInterestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching interests for user: $e');
    }
  }
}

// Example usage:
// final interestRepo = DealInterestRepository();
// await interestRepo.addInterest(
//   dealId: 'deal-uuid',
//   userId: 'user-uuid',
//   status: 'interested',
// );
// final interests = await interestRepo.getInterestsForUser('user-uuid');

