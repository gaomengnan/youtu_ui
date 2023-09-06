import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_ui/widgets/video_progress_bar/customer_video_controls.dart';

import '../data.dart';

class ChewieSingleton {
  static ChewieSingleton? _instance;
  late ChewieController _chewieController;

  ChewieSingleton._internal(
      BuildContext context, VideoPlayerController videoPlayerController, MiniplayerController? miniplayerController) {
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        looping: true,
        allowFullScreen: false,
        materialProgressColors: ChewieProgressColors(
            // backgroundColor: Colors.green,
            handleColor: Colors.red,
            // playedColor: Colors.red,
            bufferedColor: Colors.grey),
        customControls:  CustomerVideoContols(
          showPlayButton: true,
          miniplayerController: miniplayerController,
        ),
        showControls: false,
        autoPlay: false,
        showControlsOnInitialize: false,
        // hideControlsTimer: const Duration(seconds: 1),
        // placeholder: Image.network(widget.cover, fit: BoxFit.cover, width: double.infinity,),
        aspectRatio: 16 / 9);
    _chewieController.videoPlayerController.initialize().then((_) {
      _chewieController.videoPlayerController.play();
    });
  }

  factory ChewieSingleton(BuildContext context, Video video, MiniplayerController? miniplayerController) {
    _instance ??= ChewieSingleton._internal(
      context,
      VideoPlayerController.asset(video.playerUrl), miniplayerController
    );
    if (_instance?._chewieController.videoPlayerController == null) {
      _instance?._chewieController.copyWith(
          videoPlayerController: VideoPlayerController.asset(video.playerUrl));
    }
    return _instance!;
  }

  ChewieController get chewieController => _chewieController;

  // Method to change the video URL
  void changeVideoUrl(Video video, bool showControls) {
    _chewieController.videoPlayerController.pause();
    int currentPos =
        _chewieController.videoPlayerController.value.position.inSeconds;
    _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.asset(video.playerUrl),
        looping: true,
        allowFullScreen: false,
        materialProgressColors: ChewieProgressColors(
            // backgroundColor: Colors.green,
            handleColor: Colors.red,
            // playedColor: Colors.red,
            bufferedColor: Colors.grey),
        customControls: const CustomerVideoContols(
          showPlayButton: true,
        ),
        showControls: showControls,
        autoPlay: false,
        showControlsOnInitialize: false,
        // hideControlsTimer: const Duration(seconds: 1),
        // placeholder: Image.network(widget.cover, fit: BoxFit.cover, width: double.infinity,),
        aspectRatio: 16 / 9);

    _chewieController.videoPlayerController.initialize().then((_) {
      _chewieController.videoPlayerController.play();
      _chewieController.seekTo(Duration(seconds: currentPos));
    });
  }

  void showControls(bool t) {
    _chewieController = _chewieController.copyWith(showControls: t);
  }

  void dispose(){
    _instance = null;
  }
}
