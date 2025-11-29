import '../models/user_activity_model.dart';
import '../../services/supabase_service.dart';

/// Repository for user activity-related database operations
class UserActivityRepository {
  final _supabase = SupabaseService.client;

  /// Log a user activity event
  Future<void> logEvent({
    required String userId,
    String? dealId,
    required String eventType,
    String? source,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('user_activity').insert({
        'user_id': userId,
        'deal_id': dealId,
        'event_type': eventType,
        'source': source,
        'metadata': metadata,
      });
    } catch (e) {
      throw Exception('Error logging user activity: $e');
    }
  }

  /// Get all activity for a user
  Future<List<UserActivityModel>> getActivityForUser(String userId) async {
    try {
      final response = await _supabase
          .from('user_activity')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) =>
              UserActivityModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching activity for user: $e');
    }
  }
}

// Example usage:
// final activityRepo = UserActivityRepository();
// await activityRepo.logEvent(
//   userId: 'user-uuid',
//   dealId: 'deal-uuid',
//   eventType: 'view',
//   source: 'home_screen',
//   metadata: {'duration': 30},
// );
// final activities = await activityRepo.getActivityForUser('user-uuid');

