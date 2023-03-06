/// The class representing a [Message] object
/// Like an actual message when chatting
class Message {
  String id;
  String senderId;
  String recipientId;
  String content;
  DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
  });

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['senderId'],
        recipientId = json['recipientId'],
        content = json['content'],
        timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'recipientId': recipientId,
        'content': content,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}
