import 'package:flutter/material.dart';
import 'package:purple_bot/utils.dart';

import 'backend.dart';
import 'constants.dart';
import 'message-link-screen.dart';
import 'model.dart';

class ChatScreen extends StatefulWidget {
  static Route<Widget> route(ChatSession session) {
    return MaterialPageRoute(
      builder: (_) => ChatScreen(session: session),
    );
  }

  const ChatScreen({
    Key key,
    @required this.session,
  }) : super(key: key);

  final ChatSession session;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatSession _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_session.messageCount == 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _session.start(),
      );
    }
  }

  @override
  void dispose() {
    _session.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: new Text(widget.session.name),
          elevation: 0,
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                child: ChatList(
                  padding: const EdgeInsets.only(bottom: 72.0),
                  chatSession: _session,
                ),
              ),
              Container(
//              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: ChatEntryField(
                  sendMessage: _session.sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({
    Key key,
    @required this.chatSession,
    this.padding,
  }) : super(key: key);

  final ChatSession chatSession;
  final EdgeInsets padding;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.chatSession.onMessageInserted = _onMessageInserted;
    widget.chatSession.onMessageRemoved = _onMessageRemoved;
  }

  @override
  void didUpdateWidget(ChatList old) {
    super.didUpdateWidget(old);
    if (old.chatSession != widget.chatSession) {
      old.chatSession.onMessageInserted = null;
      old.chatSession.onMessageRemoved = null;
      widget.chatSession.onMessageInserted = _onMessageInserted;
      widget.chatSession.onMessageRemoved = _onMessageRemoved;
    }
  }

  @override
  void dispose() {
    widget.chatSession.onMessageInserted = null;
    widget.chatSession.onMessageRemoved = null;
    super.dispose();
  }

  void _onMessageInserted(int index, ChatMessage message) {
    _listKey.currentState
        .insertItem(0, duration: const Duration(milliseconds: 750));
  }

  void _onMessageRemoved(int index, ChatMessage message) {
    _listKey.currentState.removeItem(index, _buildRemoveMessageBuilder(message),
        duration: const Duration(milliseconds: 750));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      reverse: true,
      padding: widget.padding,
      initialItemCount: widget.chatSession.messageCount,
      itemBuilder: _buildShowMessage,
    );
  }

  Widget _buildShowMessage(
      BuildContext context, int index, Animation<double> animation) {
    final message = widget.chatSession[index];
    final sizeAnimation =
        CurvedAnimation(parent: animation, curve: const ElasticOutCurve(4.0));
    final inAnimation =
        CurvedAnimation(parent: animation, curve: Curves.elasticOut);
    return SizeTransition(
      sizeFactor: sizeAnimation,
      axisAlignment: -1.0,
      child: ScaleTransition(
        alignment: (message.from == ChatMessageFrom.Myself)
            ? Alignment.topRight
            : Alignment.topLeft,
        scale: inAnimation,
        child: FadeTransition(
          opacity: inAnimation,
          child: _buildMessage(context, message),
        ),
      ),
    );
  }

  _buildRemoveMessageBuilder(ChatMessage message) {
    return (BuildContext context, Animation<double> animation) {
      final outAnimation =
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
      return SizeTransition(
        sizeFactor: outAnimation,
        axisAlignment: 1.0,
        child: ScaleTransition(
          alignment: (message.from == ChatMessageFrom.Myself)
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
          scale: outAnimation,
          child: FadeTransition(
            opacity: outAnimation,
            child: _buildMessage(context, message),
          ),
        ),
      );
    };
  }

  Widget _buildMessage(BuildContext context, ChatMessage message) {
    final theme = Theme.of(context);
    final radius = Radius.circular(24.0);
    final myself = (message.from == ChatMessageFrom.Myself);
    return Align(
      alignment: myself ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 24.0), // TODO
        child: Builder(
          builder: (BuildContext context) {
            if (message.from == ChatMessageFrom.AutoReply) {
              return Row(
                children: message.replies
                    .map(
                      (text) => Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8.0),
                            child: FlatButton(
                              onPressed: () =>
                                  widget.chatSession.sendMessage(text),
                              textColor: theme.accentColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 36.0),
                              shape: StadiumBorder(
                                side: BorderSide(color: Colors.blueGrey[200]),
                              ),
                              child: Text(text),
                            ),
                          ),
                    )
                    .toList(growable: false),
              );
            } else if (message.link != null && message.link.isNotEmpty) {
              return InkWell(
                onTap: () => _openMessageLink(message, context),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 36.0),
                  decoration: BoxDecoration(
                    color: myself ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: myself ? radius : Radius.zero,
                      topRight: !myself ? radius : Radius.zero,
                      bottomLeft: radius,
                      bottomRight: radius,
                    ),
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                          tag: messageTag,
                          child: Image.network(
                            extractThumbnail(message.link, message.messageType),
                            height: 100,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(message.text),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 36.0),
                decoration: BoxDecoration(
                  color: myself ? Colors.blue[100] : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: myself ? radius : Radius.zero,
                    topRight: !myself ? radius : Radius.zero,
                    bottomLeft: radius,
                    bottomRight: radius,
                  ),
                ),
                child: Text(message.text),
              );
            }
          },
        ),
      ),
    );
  }

  _openMessageLink(ChatMessage message, BuildContext context) {
    setState(() => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => MessageLinkScreen(message),
              fullscreenDialog: true),
        ));
  }
}

class ChatEntryField extends StatefulWidget {
  const ChatEntryField({
    Key key,
    @required this.sendMessage,
  }) : super(key: key);

  final ValueChanged<String> sendMessage;

  @override
  _ChatEntryFieldState createState() => _ChatEntryFieldState();
}

class _ChatEntryFieldState extends State<ChatEntryField> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.grey[200],
      child: SizedBox(
        height: 48.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 8.0),
                  border: InputBorder.none,
                ),
                controller: _messageController,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              color: theme.accentColor,
              icon: Icon(Icons.arrow_forward),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.value.text;
    if (text.trim().isNotEmpty) {
      _messageController.clear();
      widget.sendMessage(text);
    }
  }
}
