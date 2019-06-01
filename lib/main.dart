import 'package:flutter/material.dart';

import 'backend_mock.dart';
import 'home_screen.dart';
import 'providers.dart';

void main() {
  final manager = MockChatManager();
  runApp(
    ChatProvider(
      manager: manager,
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent,
          splashColor: Colors.blueAccent.withOpacity(0.3),
          highlightColor: Colors.blueAccent.withOpacity(0.3),
        ),
        home: HomeScreen(),
      ),
    ),
  );
}
