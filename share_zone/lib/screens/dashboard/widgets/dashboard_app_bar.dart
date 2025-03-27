import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/screens/notification_screen/notification_screen.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: zonePink,
      automaticallyImplyLeading: false,
      title: const Text(
        "ShareZone",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Crimson",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Get.to(()=>NotificationScreen());
              },
              icon: Icon(CupertinoIcons.heart_solid),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.chat_bubble,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
