import 'package:flutter/material.dart';
import 'package:rich_link_preview/rich_link_preview.dart';

import 'model.dart';

String extractThumbnail(String url, MessageType type) {
  if (type != MessageType.Video) {
    return url;
  } else {
    String base_url = "https://img.youtube.com/vi/%/0.jpg";
    return base_url.replaceAll("%", url.split("?v=")[1]);
  }

  Widget messageTypeWidget(String link, MessageType messageType) {
    switch (messageType) {
      case MessageType.Image: {
        return Image.network(extractThumbnail(link, messageType));
      }

      break;
      case MessageType.Video: {
        return RichLinkPreview(
          link: link,
          appendToLink: true,
        );
      }
      break;

      case MessageType.Text: {

      }
    }
  }

}
