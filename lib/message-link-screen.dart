import 'package:flutter/material.dart';
import 'package:purple_bot/utils.dart';

import 'constants.dart';
import 'model.dart';

class MessageLinkScreen extends StatefulWidget {

  final ChatMessage _message;

  const MessageLinkScreen(this._message);

  @override
  _MessageLinkScreenState createState() => _MessageLinkScreenState();
}

class _MessageLinkScreenState extends State<MessageLinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._message.text),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Hero(
      tag: messageTag,
      child: Container(child: Image.network(extractThumbnail(widget._message.link, widget._message.messageType)),));
  }
}
