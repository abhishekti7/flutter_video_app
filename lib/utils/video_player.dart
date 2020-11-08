import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:video_player/video_player.dart';

class ukPlayer extends StatefulWidget {
  final String url;

  const ukPlayer({this.url});

  @override
  _ukPlayerState createState() => _ukPlayerState();
}

class _ukPlayerState extends State<ukPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.url)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      child: _controller.value.initialized
          ? GestureDetector(
        onTap: () {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(
            _controller,
          ),
        ),
      )
          : loadingVideo(),
    );
  }

  Widget loadingVideo() => Container(
    color: Colors.black,
    child: Center(
      child: GFLoader(
        type: GFLoaderType.circle,
        loaderColorOne: Colors.blueAccent,
        loaderColorTwo: Colors.black,
        loaderColorThree: Colors.pink,
      ),
    ),
  );
}
