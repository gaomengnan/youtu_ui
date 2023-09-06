import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data.dart';

class MiniPlayerWidget extends StatelessWidget {
  final double height;
  final Video video;
  final ChewieController chewieController;
  final int currentPos;
  final int totalPos;

  const MiniPlayerWidget(
      {Key? key,
      required this.height,
      required this.video,
      required this.chewieController,
      required this.currentPos,
      required this.totalPos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  height: height,
                  width: height * 2 - 20 >= MediaQuery.of(context).size.width
                      ? MediaQuery.of(context).size.width
                      : height * 2 - 20,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Chewie(
                      controller: chewieController,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 5.5,
            decoration: const BoxDecoration(
                // color: Colors.green,
                ),
            child: Consumer(
              builder: (BuildContext context,
                  T Function<T>(ProviderBase<Object?, T>) watch,
                  Widget? child) {
                return ProgressBar(
                  thumbGlowRadius: 0,
                  thumbRadius: 0,
                  progressBarColor: Colors.red,
                  progress: Duration(seconds: currentPos),
                  total: Duration(seconds: totalPos),
                  timeLabelLocation: TimeLabelLocation.none,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
