import '../models/match_group_member_model.dart';
import '../../services/supabase_service.dart';

/// Repository for match group member-related database operations
class MatchGroupMemberRepository {
  final _supabase = SupabaseService.client;

  /// Get all members for a specific group
  Future<List<MatchGroupMemberModel>> getMembersForGroup(String groupId) async {
    try {
      final response = await _supabase
          .from('match_group_members')
          .select()
          .eq('group_id', groupId)
          .order('joined_at', ascending: true);

      return (response as List)
          .map((json) =>
              MatchGroupMemberModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching members for group: $e');
    }
  }

  /// Add a member to a group
  Future<MatchGroupMemberModel> addMemberToGroup({
    required String groupId,
    required String userId,
    required String role,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
  }) async {
    try {
      final response = await _supabase
          .from('match_group_members')
          .insert({
            'group_id': groupId,
            'user_id': userId,
            'role': role,
            'delivery_address': deliveryAddress,
            'delivery_lat': deliveryLat,
            'delivery_lng': deliveryLng,
            'status': 'active',
          })
          .select()
          .single();

      return MatchGroupMemberModel.fromJson(response);
    } catch (e) {
      throw Exception('Error adding member to group: $e');
    }
  }

  /// Update member status
  Future<void> updateMemberStatus(String memberId, String status) async {
    try {
      await _supabase
          .from('match_group_members')
          .update({'status': status})
          .eq('id', memberId);
    } catch (e) {
      throw Exception('Error updating member status: $e');
    }
  }
}

// Example usage:
// final memberRepo = MatchGroupMemberRepository();
// final members = await memberRepo.getMembersForGroup('group-uuid');
// final newMember = await memberRepo.addMemberToGroup(
//   groupId: 'group-uuid',
//   userId: 'user-uuid',
//   role: 'member',
//   deliveryAddress: 'Calle Example 123',
//   deliveryLat: 40.4168,
//   deliveryLng: -3.7038,
// );
// await memberRepo.updateMemberStatus('member-uuid', 'inactive');

