import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_ui/data.dart';
import 'package:youtube_ui/screens/home_screen.dart';
import 'package:youtube_ui/screens/video_play_screen.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);
final hideBottomProvider = StateProvider<bool>((ref) => false);

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late int _selectedIndex = 0;

  final MiniplayerController miniControl = MiniplayerController();

  // 底部导航栏
  final List<BottomNavigationBarItem> _bottomBars = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
        ),
        activeIcon: Icon(Icons.home),
        label: "首页"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.explore_outlined,
        ),
        activeIcon: Icon(Icons.explore),
        label: "发现"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.add_circle_outline,
        ),
        activeIcon: Icon(Icons.add_circle),
        label: "发布"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.subscriptions_outlined,
        ),
        activeIcon: Icon(Icons.subscriptions),
        label: "订阅"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.video_library_outlined,
        ),
        activeIcon: Icon(Icons.video_library),
        label: "媒体"),
  ];

  // 导航栏对应内容展示
  final _screents = [
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text('发现'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('发布'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('订阅'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('媒体'),
      ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    miniControl.addListener(() {
      print("object");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    miniControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          var topSafe = MediaQuery.of(context).padding.top;
          return Stack(
            children: _screents
                .asMap()
                .map((i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: _selectedIndex != i,
                      child: screen,
                    )))
                .values
                .toList()
              ..add(Offstage(
                offstage: selectedVideo == null,
                child: Miniplayer(
                    controller: miniControl,
                    // backgroundColor: Colors.red,
                    elevation: 10,
                    // backgroundColor: Colors.red,
                    duration: const Duration(seconds: 1),
                    minHeight: 80,
                    maxHeight: MediaQuery.of(context).size.height - topSafe,
                    builder: (height, percentage) {
                      if (height >= 400) {
                        Future.delayed(const Duration(microseconds: 200))
                            .then((value) {
                          context.read(hideBottomProvider).state = true;
                        });
                      } else {
                        Future.delayed(const Duration(microseconds: 200))
                            .then((value) {
                          context.read(hideBottomProvider).state = false;
                        });
                      }

                      return Consumer(
                        builder: (BuildContext context,
                            T Function<T>(ProviderBase<Object?, T>) watch,
                            Widget? child) {
                          final selectedVideo =
                              watch(selectedVideoProvider).state;
                          if (selectedVideo == null) {
                            return const SizedBox.shrink();
                          }
                          return VideoPlayScreen(
                            height: height,
                            miniPlayController: miniControl,
                          );
                        },
                      );
                    }),
              )),
          );
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context, watch, _) {
          final hide = watch(hideBottomProvider).state;
          return hide
              ? const SizedBox.shrink()
              : BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: (i) {
                    setState(() => _selectedIndex = i);
                  },
                  items: _bottomBars,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                );
        },
      ),
    );
  }
}
