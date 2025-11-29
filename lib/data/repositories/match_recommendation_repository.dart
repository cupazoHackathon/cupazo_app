import '../models/match_recommendation_model.dart';
import '../../services/supabase_service.dart';

/// Repository for match recommendation-related database operations
class MatchRecommendationRepository {
  final _supabase = SupabaseService.client;

  /// Get all recommendations for a user
  Future<List<MatchRecommendationModel>> getRecommendationsForUser(
    String userId,
  ) async {
    try {
      final response = await _supabase
          .from('match_recommendations')
          .select()
          .eq('user_id', userId)
          .order('rank', ascending: true);

      return (response as List)
          .map((json) => MatchRecommendationModel.fromJson(
              json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching recommendations for user: $e');
    }
  }
}

// Example usage:
// final recRepo = MatchRecommendationRepository();
// final recommendations = await recRepo.getRecommendationsForUser('user-uuid');

