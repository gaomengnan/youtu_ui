import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_ui/screens/nav_screen.dart';
import 'package:youtube_ui/widgets/video_card.dart';
import 'package:youtube_ui/widgets/widgets.dart';

import '../data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  late int currentTopIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    // Calculate the index of the currently visible item
    int newIndex = (_scrollController.offset / 350).round();

    Video? video = context.read(selectedVideoProvider).state;

    if (newIndex != currentTopIndex && video == null) {
      setState(() {
        currentTopIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // appbar
          const CustomerSliverAppBar(),

          // 列表
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            final video = videos[index];
            return GestureDetector(
                onTap: () {
                  setState(() {
                    currentTopIndex = -1;
                  });
                  context.read(selectedVideoProvider).state = video;
                },
                child: VideoCard(
                  video: video,
                  isTop: index == currentTopIndex,
                ));
          }, childCount: videos.length))
        ],
      ),
    );
  }
}
