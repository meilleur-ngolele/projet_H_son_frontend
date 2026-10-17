class ChatConversation {
  final int id;
  final String propertyTitle;
  final String propertyImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatConversation({
    required this.id,
    required this.propertyTitle,
    required this.propertyImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? 0,
      propertyTitle: json['property_title'] ?? 'Logement H',
      propertyImage: json['property_image'] ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
      isOnline: json['is_online'] == 1 || json['is_online'] == true,
    );
  }
}

class ChatMessage {
  final int id;
  final int senderId;
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    return ChatMessage(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      text: json['message'] ?? '',
      time: json['created_at_formatted'] ?? '',
      isMe: (json['sender_id'] ?? 0) == currentUserId,
    );
  }
}