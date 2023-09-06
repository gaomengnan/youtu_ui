
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_ui/widgets/video_progress_bar/utils.dart';

import '../data.dart';

class VideoPlayerWidget extends StatefulWidget {
  final DataSourceType dataSourceType;
  final Video video;
  final Future<void>? play;
  final Future<void>? stop;
  final void Function()? listenCallback;

  final bool isTop;
  final bool showBar;

  final bool showDuration;
  final bool autoPlay;

  final ChewieController? chewieController;

  final bool isMini;

  const VideoPlayerWidget(
      {Key? key,
      required this.dataSourceType,
      required this.isTop,
      this.play,
      this.stop,
      this.showDuration = true,
      this.autoPlay = false,
      this.chewieController,
      required this.video,
      this.listenCallback,
      this.isMini = false,
      this.showBar = false})
      : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  int _currentPosition = 0;

  bool playTop = false;

  double thumbRadius = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: widget.isTop || widget.showBar
                  ? const EdgeInsets.only(bottom: 5)
                  : EdgeInsets.zero,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: widget.isTop || widget.showBar ? 1.0 : 0.0,
              duration: const Duration(microseconds: 100),
              child: Container(
                height: 10,
                decoration: const BoxDecoration(
                    // color: Colors.red
                    ),
                child: ProgressBar(
                  onDragUpdate: (e) {},
                  onSeek: (e) {
                    _chewieController.seekTo(Duration(seconds: e.inSeconds));
                  },
                  progressBarColor: Colors.red,
                  thumbColor: Colors.red,
                  thumbRadius: thumbRadius,
                  thumbGlowRadius: 1,
                  timeLabelLocation: TimeLabelLocation.none,
                  barHeight: 3,
                  progress: Duration(seconds: _currentPosition),
                  total: Duration(
                      seconds: _chewieController
                          .videoPlayerController.value.duration.inSeconds),
                ),
              ),
            ),
            if (widget.showDuration)
              Positioned(
                  bottom: 28,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    color: Colors.black,
                    child: const Text("07:09"),
                  )),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.chewieController != null) {
      _chewieController = widget.chewieController!;
      _videoPlayerController = _chewieController.videoPlayerController;
    } else {
      _chewieController = getInstance(
          widget.video, widget.dataSourceType, widget.autoPlay, null);
      _videoPlayerController = _chewieController.videoPlayerController;

      _videoPlayerController.addListener(() {
        setState(() {
          _currentPosition = _videoPlayerController.value.position.inSeconds;
        });
        if (widget.isMini) {}
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isTop) {
      if (!_chewieController.isPlaying) {
        _chewieController.setVolume(0);
        _chewieController.play();
      }
    } else {
      if (_chewieController.isPlaying) {
        _chewieController.seekTo(Duration.zero);
        _chewieController.pause();
      }
    }
  }
}
