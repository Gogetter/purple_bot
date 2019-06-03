import 'model.dart';

String extractThumbnail(String url, MessageType type) {
  if (type != MessageType.Video) {
    return url;
  } else {
    String base_url = "https://img.youtube.com/vi/%/0.jpg";
    return base_url.replaceAll("%", url.split("?v=")[1]);
  }
}