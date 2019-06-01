import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'constants.dart';
import 'model.dart';

class WebviewScreen extends StatelessWidget {
  final ChatMessage _message;
  const WebviewScreen(this._message);

  @override
  Widget build(BuildContext context) {

    return WebviewScaffold(
      url: _message.link,
      appBar: AppBar(
        //TODO: use message title here
//        title: Text(_message.text),
        title: Container(),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Hero(
        tag: messageTag,
        child: Container(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
