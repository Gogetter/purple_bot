import 'dart:async';
import 'dart:math' show Random;

import 'backend.dart';
import 'model.dart';

class MockChatManager extends ChatManager {
  Map<String, ChatSession> _cache = {};

  @override
  ChatSession getNamedSession(String name) {
    var session = _cache[name];
    if (session == null) {
      session = MockChatSession(name);
      _cache[name] = session;
    }
    return session;
  }
}

class MockChatSession extends ChatSession {
  final Random _random = Random();

  static const _fakeText = <String>[
    'Hi there, Welcome to Purple Bot',
    'Welcome, %! What\'s your email?',
    '%, got it! is it ok if we reach out.'
  ];

  int _fakeCount = 0;

  double _rating;

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  ChatMessage operator [](int index) => _messages[index];

  @override
  int get messageCount => _messages.length;

  @override
  double get rating => double.parse(_rating.toStringAsFixed(1));

  MockChatSession(String name) : super(name) {
    _rating = _random.nextDouble() * 5.0;
  }

  @override
  void start() {
    _sendToServer(null);
  }

  @override
  void close() {
    // TODO: End session
  }

  @override
  void sendMessage(String text) {
    _insertMessage(ChatMessage.fromMyself(text));
    _sendToServer(text);
  }

  void _insertMessage(ChatMessage message) {
    _messages.insert(0, message);
    if (onMessageInserted != null) {
      onMessageInserted(0, message);
    }
    if (message.from == ChatMessageFrom.Myself && _messages.length >= 2) {
      final item = _messages[1];
      if (item.from == ChatMessageFrom.AutoReply) {
        _messages.removeAt(1);
        if (onMessageRemoved != null) {
          onMessageRemoved(1, item);
        }
      }
    }
  }

  void _sendToServer(String text) async {
    if (text != null) {
      await Future.delayed(Duration(seconds: _random.nextInt(3)));
    }
    if (_fakeCount < _fakeText.length) {
      var response = _fakeText[_fakeCount];
      if (text != null) {
        response = response.replaceAll('%', text);
      }
      _insertMessage(ChatMessage.fromServer(response));
    }
    _fakeCount++;
    if (_fakeCount == _fakeText.length) {
      _insertMessage(ChatMessage.forAutoReply(['Yes', 'No']));
    }
  }
}
