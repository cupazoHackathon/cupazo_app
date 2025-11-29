import '../models/match_group_model.dart';
import '../../services/supabase_service.dart';

/// Repository for match group-related database operations
class MatchGroupRepository {
  final _supabase = SupabaseService.client;

  /// Get all groups for a specific deal
  Future<List<MatchGroupModel>> getGroupsForDeal(String dealId) async {
    try {
      final response = await _supabase
          .from('match_groups')
          .select()
          .eq('deal_id', dealId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => MatchGroupModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching groups for deal: $e');
    }
  }

  /// Create a new match group
  Future<MatchGroupModel> createGroup({
    required String dealId,
    required int maxGroupSize,
    required String status,
  }) async {
    try {
      final response = await _supabase
          .from('match_groups')
          .insert({
            'deal_id': dealId,
            'max_group_size': maxGroupSize,
            'status': status,
          })
          .select()
          .single();

      return MatchGroupModel.fromJson(response);
    } catch (e) {
      throw Exception('Error creating match group: $e');
    }
  }

  /// Get a group by its ID
  Future<MatchGroupModel?> getGroupById(String id) async {
    try {
      final response = await _supabase
          .from('match_groups')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return MatchGroupModel.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching group by id: $e');
    }
  }
}

// Example usage:
// final groupRepo = MatchGroupRepository();
// final groups = await groupRepo.getGroupsForDeal('deal-uuid');
// final newGroup = await groupRepo.createGroup(
//   dealId: 'deal-uuid',
//   maxGroupSize: 6,
//   status: 'open',
// );
// final group = await groupRepo.getGroupById('group-uuid');

