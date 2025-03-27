import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/constants/color.dart';


class ExplorationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;

  const ExplorationAppBar({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: zonePink,
      automaticallyImplyLeading: false,
      leading: isSearching ?
      IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Get.back(),
      )
      : null,
    title: const Text(
    "ShareZone",
    style: TextStyle(
    color: Colors.white,
    fontFamily: "Crimson",
    fontSize: 30,
      fontWeight: FontWeight.bold,
    ),)
    ,
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
