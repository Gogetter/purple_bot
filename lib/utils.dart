

String extractThumbnail(String url) {
  String base_url = "https://img.youtube.com/vi/%/0.jpg";
  return base_url.replaceAll("%", url.split("?v=")[1]);
}


