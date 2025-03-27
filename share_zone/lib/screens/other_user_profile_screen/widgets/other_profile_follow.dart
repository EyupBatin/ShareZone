import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/screens/follower_screen/follower_screen.dart';
import 'package:share_zone/screens/following_screen/following_screen.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/modules/main_module/user_image.dart';

class OtherProfileFollow extends StatefulWidget {
  final RxString user_id; // user_id'yi widget'a geçiriyoruz

  const OtherProfileFollow({required this.user_id, super.key});

  @override
  State<OtherProfileFollow> createState() => _OtherProfileFollowState();
}

class _OtherProfileFollowState extends State<OtherProfileFollow> {
  late UserController userController;

  @override
  void initState() {
    super.initState();
    // Tag ile UserController'ı başlatıyoruz
    userController = Get.put(UserController(), tag: widget.user_id.value);
  }



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            UserImage(
              user_id: widget.user_id.value, isBig: true,
            ),
            Obx(
              () => Text(
                  "${userController.getUserName} "
                  "${userController.getUserSurname}",
                  style: const TextStyle(
                    color: textColor,
                  )),
            ),
          ],
        ),
        Container(
          child: Column(
            children: [
              Obx(() => Text("${userController.getUserPostsController()}",
                  style: const TextStyle(
                    color: textColor,
                  ))),
              const Text("Posts ",
                  style: TextStyle(
                    color: textColor,
                  )),
            ],
          ),
        ),
        InkWell(
          highlightColor: Colors.grey,
          onTap: () {
            userController.setUserIdController(widget.user_id.value);
            Future.delayed(
              const Duration(seconds: 2),
              () => Get.to(() => FollowerScreen(
                    user_id: userController.getUserIdController(),
                  )),
            );
          },
          child: Column(children: [
            Obx(() => Text("${userController.getUserFollowersController()}",
                style: const TextStyle(
                  color: textColor,
                ))),
            const Text(
              "Followers",
              style: TextStyle(
                color: textColor,
              ),
            ),
          ]),
        ),
        InkWell(
          highlightColor: Colors.grey,
          onTap: () {
            userController.setUserIdController(widget.user_id.value);
            Future.delayed(
              Duration(seconds: 2),
              () => Get.to(() => FollowingScreen(
                    user_id: userController.getUserIdController(),
                  )),
            );
          },
          child: Column(
            children: [
              Obx(() => Text("${userController.getUserFollowingController()}",
                  style: const TextStyle(
                    color: textColor,
                  ))),
              const Text(
                "Following",
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
