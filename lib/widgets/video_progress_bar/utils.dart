import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../data.dart';
import 'customer_video_controls.dart';

ChewieController getInstance(Video video, DataSourceType dataSourceType, bool autoPlay, void Function(VideoPlayerController)? listenCallback){
  VideoPlayerController videoPlayerController;
  switch (dataSourceType) {
    case DataSourceType.asset:
      videoPlayerController = VideoPlayerController.asset(video.playerUrl);
      break;
    case DataSourceType.network:
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(video.playerUrl));
      break;
    case DataSourceType.file:
      videoPlayerController = VideoPlayerController.file(File(video.playerUrl));
      break;
    case DataSourceType.contentUri:
      videoPlayerController =
          VideoPlayerController.contentUri(Uri.parse(video.playerUrl));
      break;
  }
  if(listenCallback != null) {
    videoPlayerController.addListener((){
    listenCallback(videoPlayerController);
  });
  }
  return  ChewieController(
      allowFullScreen: false,
      materialProgressColors: ChewieProgressColors(
        // backgroundColor: Colors.green,
          handleColor: Colors.red,
          // playedColor: Colors.red,
          bufferedColor: Colors.grey),
      customControls: const CustomerVideoContols(
        showPlayButton: true,
      ),
      showControls: false,
      autoPlay: autoPlay,
      autoInitialize: true,
      showControlsOnInitialize: false,
      // hideControlsTimer: const Duration(seconds: 1),
      // placeholder: Image.network(widget.cover, fit: BoxFit.cover, width: double.infinity,),
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9);
}