import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_ui/screens/nav_screen.dart';

import '../utils/dimensions.dart';
import '../widgets/video_player_singleton.dart';

final currentPosProvider = StateProvider<int>((ref) => 0);
final currentTotalPosProvider = StateProvider<int>((ref) => 0);

final playStatusChangeProvider = StateProvider<bool>((ref) => false);

class VideoPlayScreen extends ConsumerWidget {
  final double height;
  final MiniplayerController? miniPlayController;

  const VideoPlayScreen(
      {Key? key, required this.height, this.miniPlayController})
      : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final selectedVideo = watch(selectedVideoProvider).state;
    if (selectedVideo == null) return const SizedBox.shrink();
    ChewieSingleton chewieSingleton =
        ChewieSingleton(context, selectedVideo, miniPlayController);
    final screentHeight = MediaQuery.of(context).size.height;
    chewieSingleton.showControls(height >= screentHeight / 2);
    chewieSingleton.chewieController.videoPlayerController.addListener(() {
      context.read(currentPosProvider).state = chewieSingleton
          .chewieController.videoPlayerController.value.position.inSeconds;
      context.read(currentTotalPosProvider).state = chewieSingleton
          .chewieController.videoPlayerController.value.duration.inSeconds;
    });
    // miniplay
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              // backgroundColor: Colors.green,
              pinned: true,
              toolbarHeight: screentHeight * 0.23,
              expandedHeight: screentHeight * 0.23,
              flexibleSpace: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              // height: he,
                              width: height < 150
                                  ? 150
                                  : MediaQuery.of(context).size.width,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Chewie(
                                  controller: chewieSingleton.chewieController,
                                ),
                              ),
                            ),
                          ),
                          if (height <= 100)
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Coing a Real timas ",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "爱迪生",
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.4)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Consumer(
                                        builder: (context, watch, _) {
                                          final playStatus =
                                              watch(playStatusChangeProvider)
                                                  .state;
                                          return Container(
                                              child: IconButton(
                                            onPressed: () {
                                              chewieSingleton.chewieController
                                                  .togglePause();

                                              context
                                                      .read(
                                                          playStatusChangeProvider)
                                                      .state =
                                                  chewieSingleton
                                                      .chewieController
                                                      .isPlaying;
                                            },
                                            icon: playStatus
                                                ? const Icon(Icons.pause)
                                                : const Icon(Icons.play_arrow),
                                          ));
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                          onPressed: () {
                                            chewieSingleton.chewieController
                                                .pause();
                                            // miniPlayController?.animateToHeight(height: 0);
                                            context
                                                .read(selectedVideoProvider)
                                                .state = null;
                                            chewieSingleton.dispose();
                                          },
                                          icon: const Icon(
                                            Icons.close_rounded,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                      Container(
                        height: 10,
                        decoration: const BoxDecoration(
                            // color: Colors.green,
                            ),
                        child: Consumer(
                          builder: (BuildContext context,
                              T Function<T>(ProviderBase<Object?, T>) watch,
                              Widget? child) {
                            final curPos = watch(currentPosProvider).state;
                            final curtotalPos =
                                watch(currentTotalPosProvider).state;

                            return ProgressBar(
                              onSeek: (Duration? sk) {
                                chewieSingleton.chewieController.seekTo(sk!);
                              },
                              thumbGlowRadius: 0,
                              thumbRadius: 3,
                              thumbColor: Colors.red,
                              progressBarColor: Colors.red,
                              progress: Duration(seconds: curPos),
                              total: Duration(seconds: curtotalPos),
                              timeLabelLocation: TimeLabelLocation.none,
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return ListTile(
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "79万次观看",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.4)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "11小时前",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.4)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "...展开",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                        title: const Text(
                          "WMS系统是一款仓储管理系统，目前PC端产品相对完",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    }
                    if (index == 1) {
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () {},
                          child: const CircleAvatar(
                              foregroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/128/924/924915.png")),
                        ),
                        title: Row(
                          children: const [
                            Text(
                              '老王说故事',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '585万',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 11),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          width: 70,
                          height: 40,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(Icons.notifications_none),
                              Icon(Icons.keyboard_arrow_down_outlined)
                            ],
                          ),
                        ),
                      );
                    }

                    if (index == 2) {
                      return SizedBox(
                        height: screentHeight * 0.05,
                        // color: Colors.orange,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                child: FilledButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey.withOpacity(0.2))),
                                  onPressed: () {},
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.thumb_up_off_alt,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "199",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(),
                                      ),
                                      Icon(
                                        Icons.thumb_down_off_alt,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            var icon = Dimensions.iconList[index - 1];
                            return _buildIconList(icon["icon"] as IconData,
                                icon["title"] as String);
                          },
                          itemCount: 4,
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () {},
                      child: const ListTile(
                        title: Text("asdad"),
                      ),
                    );
                  },
                  childCount: 20,
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildIconList(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: FilledButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.grey.withOpacity(0.2))),
        onPressed: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
