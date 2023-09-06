import 'package:chewie/src/chewie_progress_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_ui/widgets/video_progress_bar/video_progress_bar.dart';

class CustomerVideoProgressBar extends StatelessWidget {
  CustomerVideoProgressBar(
      this.controller, {
        this.height = kToolbarHeight,
        ChewieProgressColors? colors,
        this.onDragEnd,
        this.onDragStart,
        this.onDragUpdate,
        Key? key,
      })  : colors = colors ?? ChewieProgressColors(),
        super(key: key);

  final double height;
  final VideoPlayerController controller;
  final ChewieProgressColors colors;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return VideoProgressBar(
      controller,
      barHeight: 4,
      handleHeight: 6,
      drawShadow: true,
      colors: colors,
      onDragEnd: onDragEnd,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
    );
  }
}