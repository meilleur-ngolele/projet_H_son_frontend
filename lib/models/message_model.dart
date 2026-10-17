class MessageItem {
  final int id;
  final String propertyTitle;
  final String message;
  final String createdAt;

  MessageItem({
    required this.id,
    required this.propertyTitle,
    required this.message,
    required this.createdAt,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      id: json['id'] ?? 0,
      propertyTitle: json['property_title'] ?? 'Discussion',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}