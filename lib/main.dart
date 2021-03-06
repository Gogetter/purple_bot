import 'package:flutter/material.dart';

import 'backend_dialogflow.dart';
import 'chat_screen.dart';
import 'providers.dart';

void main() {
  final manager = DialogFlowChatManager();
//  final manager = MockChatManager();
  runApp(
    ChatProvider(
      manager: manager,
      child: MaterialApp(
        title: 'Flutter?',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent,
          splashColor: Colors.blueAccent.withOpacity(0.3),
          highlightColor: Colors.blueAccent.withOpacity(0.3),
        ),
//        home: ChatScreen(session: MockChatSession("Purple Bot")),
        home: ChatScreen(session: DialogFlowChatSession("Purple Bot")),
      ),
    ),
  );
}
