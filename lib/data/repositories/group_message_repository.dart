import '../models/group_message_model.dart';
import '../../services/supabase_service.dart';

/// Repository for group message-related database operations
class GroupMessageRepository {
  final _supabase = SupabaseService.client;

  /// Get all messages for a group
  Future<List<GroupMessageModel>> getMessagesForGroup(String groupId) async {
    try {
      final response = await _supabase
          .from('group_messages')
          .select()
          .eq('group_id', groupId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) =>
              GroupMessageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching messages for group: $e');
    }
  }

  /// Send a message to a group
  Future<GroupMessageModel> sendMessage({
    required String groupId,
    required String senderId,
    required String content,
    bool isSystemMessage = false,
  }) async {
    try {
      final response = await _supabase
          .from('group_messages')
          .insert({
            'group_id': groupId,
            'sender_id': senderId,
            'content': content,
            'is_system_message': isSystemMessage,
          })
          .select()
          .single();

      return GroupMessageModel.fromJson(response);
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}

// Example usage:
// final messageRepo = GroupMessageRepository();
// final messages = await messageRepo.getMessagesForGroup('group-uuid');
// final newMessage = await messageRepo.sendMessage(
//   groupId: 'group-uuid',
//   senderId: 'user-uuid',
//   content: 'Hello everyone!',
//   isSystemMessage: false,
// );

