import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'providers.dart';
import 'widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbar(
        title: 'Chat App',
      ),
      body: ListView.separated(
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          final name = 'Mock ${index + 1}';
          final session = ChatProvider.of(context).getNamedSession(name);
          return Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(ChatScreen.route(session)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber[800],
                  child: Text(
                    session.rating.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(name),
                subtitle: RatingBar(
                  rating: session.rating,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
    );
  }
}
