import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_ui/widgets/video_player_widget.dart';

import '../data.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final bool isTop;

  const VideoCard({Key? key, required this.video, required this.isTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 视频
        Stack(
          children: [
            VideoPlayerWidget(
              video: video,
              dataSourceType: DataSourceType.asset,
              isTop: isTop,
            ),
          ],
        ),
        //视频介绍
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                    foregroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/128/924/924915.png")),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Text(
                      "yncing files to device iPhone 13 Pro...",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                    Flexible(
                        child: Text(
                      "Restarted application in 821ms.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ))
                  ],
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.more_vert,
                  size: 20,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
