enum ChatMessageFrom {
  Myself,
  Server,
  AutoReply,
}

class ChatMessage {
  final ChatMessageFrom from;
  final String text;
  final List<String> replies;

  const ChatMessage.forAutoReply(this.replies)
      : this.from = ChatMessageFrom.AutoReply,
        this.text = null;

  const ChatMessage.fromServer(this.text)
      : this.from = ChatMessageFrom.Server,
        this.replies = null;

  const ChatMessage.fromMyself(this.text)
      : this.from = ChatMessageFrom.Myself,
        this.replies = null;
}
