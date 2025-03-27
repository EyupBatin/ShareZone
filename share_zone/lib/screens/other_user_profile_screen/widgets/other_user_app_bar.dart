import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_zone/constants/color.dart';


class OtherUserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OtherUserAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: barColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: textColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "ShareZone",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Crimson",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
