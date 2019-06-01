enum ChatMessageFrom {
  Myself,
  Server,
  AutoReply,
}

enum MessageType {
  Text,
  Video,
  Image
}

class ChatMessage {
  final ChatMessageFrom from;
  final String text;
  final String link;
  final MessageType messageType;
  final List<String> replies;

  const ChatMessage.forAutoReply(this.replies)
      : this.from = ChatMessageFrom.AutoReply,
        this.link = null,
        this.messageType = MessageType.Text,
        this.text = null;

  const ChatMessage.fromServer(this.text,[this.link, this.messageType])
      : this.from = ChatMessageFrom.Server,
        this.replies = null;

  const ChatMessage.fromMyself(this.text)
      : this.from = ChatMessageFrom.Myself,
        this.link = null,
        this.messageType = MessageType.Text,
        this.replies = null;
}
