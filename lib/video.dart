import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({this.videoUrl}) : assert(videoUrl != null);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState(videoUrl);
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final VideoPlayerController videoPlayerController;
  final String videoUrl;
  double videoDuration = 0;
  double currentDuration = 0;
  _VideoPlayerWidgetState(this.videoUrl)
      : videoPlayerController = VideoPlayerController.network(videoUrl);

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize().then((_) {
         videoDuration =
            videoPlayerController.value.duration.inMilliseconds.toDouble();

    });

    videoPlayerController.addListener(() {
    currentDuration = videoPlayerController.value.position.inMilliseconds.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Center(
            child: Container(
              color: Colors.blueGrey,
              constraints: BoxConstraints(maxHeight: 200),
              child: videoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController),
                    )
                  : Container(
                      height: 200,
                      color: Theme.of(context).colorScheme.primary,
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          Slider(
            value: currentDuration,
            max: videoDuration,
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (value) => videoPlayerController
                .seekTo(Duration(milliseconds: value.toInt())),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:24.0),
            child: GestureDetector(
                child: Icon(
                  videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                onTap: () {
                  setState(() {
                    videoPlayerController.value.isPlaying
                        ? videoPlayerController.pause()
                        : videoPlayerController.play();
                  });
                }),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
