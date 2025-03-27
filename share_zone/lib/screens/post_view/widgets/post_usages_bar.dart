import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/constants/color.dart';

class PostUsagesBar extends StatelessWidget {
  PostUsagesBar({super.key});

  RxBool isLiked = false.obs;
  RxBool isSaved = false.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => IconButton(
              onPressed: () {
                isLiked.value = !isLiked.value;
              },
              icon: isLiked.value
                  ? const Icon(
                      CupertinoIcons.heart_solid,
                      color: Colors.red,
                      size: 22,
                    )
                  : const Icon(
                      CupertinoIcons.heart,
                      color: textColor,
                      size: 22,
                    ),
            )),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.chat_bubble,
            color: textColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.paperplane,
            color: textColor,
          ),
        ),
        const Spacer(),
        Obx(
          () => IconButton(
            onPressed: () {
              isSaved.value = !isSaved.value;
            },
            icon: isSaved.value
                ? const Icon(
                    CupertinoIcons.bookmark_fill,
                    color: textColor,
                  )
                : const Icon(
                    CupertinoIcons.bookmark,
                    color: textColor,
                  ),
          ),
        ),
      ],
    );
  }
}
