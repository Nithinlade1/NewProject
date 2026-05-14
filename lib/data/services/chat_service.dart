import '../models/chat_message_model.dart';

abstract class ChatService {
  Future<List<ChatMessageModel>> getMessages(String kutId);
  Future<ChatMessageModel> sendMessage(String kutId, String text);
}

class MockChatService implements ChatService {
  final Map<String, List<ChatMessageModel>> _chats = {
    'k1': [
      ChatMessageModel(id: '1', text: 'Hello, I need your service tomorrow', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30))),
      ChatMessageModel(id: '2', text: 'Sure, I will be available. What time works for you?', isSent: true, timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 28))),
      ChatMessageModel(id: '3', text: 'Around 9 AM would be great', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 27))),
      ChatMessageModel(id: '4', text: 'Perfect, I will be there at 9 AM', isSent: true, timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 25))),
    ],
    'k3': [
      ChatMessageModel(id: '5', text: 'Can you deliver today?', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 5))),
      ChatMessageModel(id: '6', text: 'Yes, I can deliver by evening', isSent: true, timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45))),
      ChatMessageModel(id: '7', text: 'Great, thanks!', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 40))),
    ],
    'k6': [
      ChatMessageModel(id: '8', text: 'Is the service available this week?', isSent: false, timestamp: DateTime.now().subtract(const Duration(days: 1))),
      ChatMessageModel(id: '9', text: 'Yes, what day works best?', isSent: true, timestamp: DateTime.now().subtract(const Duration(hours: 23))),
    ],
    'k9': [
      ChatMessageModel(id: '10', text: 'Hello!', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 6))),
      ChatMessageModel(id: '11', text: 'Hi, how can I help?', isSent: true, timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 50))),
      ChatMessageModel(id: '12', text: 'I need plumbing service', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 45))),
      ChatMessageModel(id: '13', text: 'I can come by 3 PM today', isSent: true, timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 40))),
      ChatMessageModel(id: '14', text: 'That works perfectly, thank you!', isSent: false, timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 35))),
    ],
  };

  @override
  Future<List<ChatMessageModel>> getMessages(String kutId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_chats[kutId] ?? []);
  }

  @override
  Future<ChatMessageModel> sendMessage(String kutId, String text) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final message = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isSent: true,
      timestamp: DateTime.now(),
    );
    _chats.putIfAbsent(kutId, () => []).add(message);
    return message;
  }
}
