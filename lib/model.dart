enum ChatMessageFrom {
  Myself,
  Server,
  AutoReply,
}

class ChatMessage {
  final ChatMessageFrom from;
  final String text;
  final String link;
  final List<String> replies;

  const ChatMessage.forAutoReply(this.replies)
      : this.from = ChatMessageFrom.AutoReply,
        this.link = null,
        this.text = null;

  const ChatMessage.fromServer(this.text,[this.link])
      : this.from = ChatMessageFrom.Server,
        this.replies = null;

  const ChatMessage.fromMyself(this.text)
      : this.from = ChatMessageFrom.Myself,
        this.link = null,
        this.replies = null;
}
