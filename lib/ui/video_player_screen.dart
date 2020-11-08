import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:yello_video_player/ui/camera_screen.dart';
import 'package:yello_video_player/widgets/resuable_card.dart';

class VideoPlayerScreen extends StatefulWidget {

  final VideoPlayerController videoPlayerController;
  final bool looping;

  VideoPlayerScreen(
      {@required this.videoPlayerController, this.looping, Key key})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  double top = 20;
  double left = 20;
  ChewieController _chewieController;

  double volume = 100.0;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        overlay: Container(
          child: CameraScreen()
        ),
        autoPlay: true,
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black
    ));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Chewie(
            controller: _chewieController,
          ),
          ReusableCard(
            color: Colors.transparent,
            cardChild: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                inactiveTrackColor: Color(0xFF8D8E98),
                activeTrackColor: Colors.white,
                thumbColor: Color(0xFFEB1555),
                overlayColor: Color(0x29EB1555),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
              ),
              child: Slider(
                value: volume,
                min: 0.0,
                max: 100.0,
                onChanged: (double newValue){
                  setState(() {
                    volume = newValue;
                    _chewieController.setVolume(volume);
                    if(volume==0.0){
                      Toast.show("Video Muted", context);
                    }
                  });
                },
              ),
            ),
            margin: 8.0,
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

}


