import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:purple_bot/utils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'constants.dart';
import 'model.dart';


class VideoPlayerScreen extends StatefulWidget {
  final ChatMessage _message;
  VideoPlayerScreen(this._message);

  @override
  _VideoPlayerScreenState createState() => new _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    _controller = VideoPlayerController.network(widget._message.link);

    _initializeVideoPlayerFuture = _controller.initialize();

    _initializeVideoPlayerFuture.then((_) => _controller.play());

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Container()),
        body: FutureBuilder(
    future: _initializeVideoPlayerFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  )

    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

