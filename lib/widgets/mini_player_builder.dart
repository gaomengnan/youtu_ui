import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_ui/screens/nav_screen.dart';
import 'package:youtube_ui/screens/video_play_screen.dart';

class MiniPlayerBuilder extends StatelessWidget {
  const MiniPlayerBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        return;
      },
      child: Miniplayer(
          // backgroundColor: Colors.red,
          elevation: 10,
          // backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
          minHeight: 90,
          maxHeight: MediaQuery.of(context).size.height -125,
          builder: (height, percentage) {
            return Consumer(
              builder: (BuildContext context,
                  T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) {
                final selectedVideo = watch(selectedVideoProvider).state;
                if (selectedVideo == null) return const SizedBox.shrink();
                return VideoPlayScreen(height: height,);
              },
            );
          }),
    );
  }
}
