import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'backend.dart';
import 'model.dart';

class DialogFlowChatManager extends ChatManager {
  Map<String, ChatSession> _cache = {};

  @override
  ChatSession getNamedSession(String name) {
    var session = _cache[name];
    if (session == null) {
      session = DialogFlowChatSession(name);
      _cache[name] = session;
    }
    return session;
  }
}

class DialogFlowChatSession extends ChatSession {

  Dialogflow dialogflow;

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  ChatMessage operator [](int index) => _messages[index];

  @override
  int get messageCount => _messages.length;

  DialogFlowChatSession(String name) : super(name);

  @override
  void start() async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/gc-service-account.json").build();
    this.dialogflow = Dialogflow(authGoogle: authGoogle,language: Language.english);
    _insertMessage(ChatMessage.fromServer('Hi! How can I help you?'));
  }

  @override
  void close() {
    // TODO: End session
  }

  @override
  void sendMessage(String text) {
    if (text == null) {
      return;
    }
    _insertMessage(ChatMessage.fromMyself(text));
    _sendToServer(text);
  }

  void _insertMessage(ChatMessage message) {
    _messages.insert(0, message);

    if (onMessageInserted != null) {
      onMessageInserted(0, message);
    }

    if (message.from == ChatMessageFrom.Myself && _messages.length >= 2) {
        final previousMessage = _messages[1];

        if(previousMessage.from != ChatMessageFrom.AutoReply) {
          return;
        }

        _messages.removeAt(1);
        if(onMessageRemoved != null) {
          onMessageRemoved(1, previousMessage);
        }
    }
  }

  void _sendToServer(String text) async {
    AIResponse response = await dialogflow.detectIntent(text);
    _insertMessage(ChatMessage.fromServer(response.getMessage()));
  }
}
