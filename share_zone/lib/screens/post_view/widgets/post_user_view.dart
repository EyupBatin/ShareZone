import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/modules/main_module/user_image.dart';
import 'package:share_zone/screens/other_user_profile_screen/other_user_profile_screen.dart';
import 'package:share_zone/screens/profile_screen/profile_screen.dart';
import 'package:share_zone/services/api_service.dart';

class PostUserView extends StatelessWidget {
  final String user_id;

  PostUserView({super.key, required this.user_id});

  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiService.fetchFollowData(user_id,userController),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return GestureDetector(
            onTap: () {
              String selectedId = user_id;
              if (selectedId ==
                  userController.getLoginUserIdController().value) {
                Get.to(() => ProfileScreen());
              } else {
                Get.to(() => OtherUserProfileScreen(
                    user_id: userController.getUserIdController()));
              }
            },
            child: Container(
              child: Row(
                children: [
                  UserImage(user_id: user_id, isBig: false),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                        "${userController.getUserName} "
                        "${userController.getUserSurname}",
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
