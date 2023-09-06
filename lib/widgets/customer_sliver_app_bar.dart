import 'package:flutter/material.dart';

class CustomerSliverAppBar extends StatelessWidget {
  const CustomerSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 50,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset(
          "assets/images/youtube.png",
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.cast)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () {},
            icon: const CircleAvatar(
              foregroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/128/924/924915.png"),
            )),
      ],
    );
  }
}
