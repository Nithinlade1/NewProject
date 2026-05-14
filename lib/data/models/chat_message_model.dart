class ChatMessageModel {
  final String id;
  final String text;
  final bool isSent;
  final DateTime timestamp;
  final MessageType type;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.type = MessageType.text,
  });

  String get formattedTime {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isSent': isSent,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isSent: json['isSent'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
    );
  }
}

enum MessageType { text, image, callLog, system }
