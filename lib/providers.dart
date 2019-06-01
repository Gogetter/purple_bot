import 'package:flutter/material.dart';

import 'backend.dart';

class ChatProvider extends InheritedWidget {
  const ChatProvider({
    Key key,
    this.manager,
    Widget child,
  }) : super(key: key, child: child);

  final ChatManager manager;

  static ChatManager of(BuildContext context) {
    ChatProvider provider = context.inheritFromWidgetOfExactType(ChatProvider);
    return provider?.manager;
  }

  @override
  bool updateShouldNotify(ChatProvider old) => old.manager != manager;
}
