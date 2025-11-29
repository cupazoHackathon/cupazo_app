/// Group message model representing the `group_messages` table
class GroupMessageModel {
  final String id;
  final String groupId;
  final String senderId;
  final String content;
  final bool isSystemMessage;
  final DateTime createdAt;

  GroupMessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.isSystemMessage,
    required this.createdAt,
  });

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) {
    return GroupMessageModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      isSystemMessage: json['is_system_message'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'sender_id': senderId,
      'content': content,
      'is_system_message': isSystemMessage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

