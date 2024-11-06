import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PresentationVideoPlayer extends StatefulWidget {
  final String asset;

  const PresentationVideoPlayer({
    required this.asset,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PresentationVideoPlayerState();
}

class _PresentationVideoPlayerState extends State<PresentationVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_controller.value.isInitialized) return;
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      child: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
