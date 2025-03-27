import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/screens/follower_screen/follower_screen.dart';
import 'package:share_zone/screens/following_screen/following_screen.dart';
import 'package:share_zone/modules/main_module/user_image.dart';

class ProfileFollow extends StatelessWidget {
  ProfileFollow({super.key});

  final UserController userController = Get.find();

  Future<void> fetchFollowData() async {
    try {
      final response = await http.get(
        Uri.parse("${Ip4Url.baseUrl}/api/get_follows/"
            "${userController.getLoginUserIdController().value}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userController.setUserFollowersController(data['followers']);
        userController.setUserName(data['name']);
        userController.setUserSurname(data['surname']);
        userController.setUserFollowingController(data['following']);
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFollowData(), // API isteğini burada çağırıyoruz
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Yükleniyor göstergesi
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                UserImage(
                  isBig: true,
                  user_id: userController.getLoginUserIdController().value,
                ),
                Obx(
                  () => Text(
                      "${userController.getUserName} "
                      "${userController.getUserSurname} ",
                      style: TextStyle(color: textColor)),
                )
              ],
            ),
            Column(
              children: [
                Text("${userController.getUserPostsController()}",
                    style: TextStyle(color: textColor)),
                Text("Posts ", style: TextStyle(color: textColor)),
              ],
            ),
            InkWell(
              highlightColor: Colors.grey,
              onTap: () {
                Future.delayed(
                    Duration(seconds: 2),
                    () => Get.to(() => FollowerScreen(
                          user_id: userController.getLoginUserIdController(),
                        )));
              },
              child: Column(children: [
                Text(
                  "${userController.getUserFollowersController()}",
                  style: TextStyle(color: textColor),
                ),
                Text("Followers", style: TextStyle(color: textColor)),
              ]),
            ),
            InkWell(
              highlightColor: Colors.grey,
              onTap: () {
                Future.delayed(
                    Duration(seconds: 2),
                    () => Get.to(() => FollowingScreen(
                          user_id: userController.getLoginUserIdController(),
                        )));
              },
              child: Obx(
                () => Column(
                  children: [
                    Text(
                      "${userController.getUserFollowingController()}",
                      style: TextStyle(color: textColor),
                    ),
                    Text("Following", style: TextStyle(color: textColor)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
