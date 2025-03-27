import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/image_controller.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/modules/main_module/my_navigation_bar.dart';
import 'package:share_zone/screens/profile_screen/widgets/profile_app_bar.dart';
import 'package:share_zone/screens/profile_screen/widgets/profile_button.dart';
import 'package:share_zone/screens/profile_screen/widgets/profile_follow.dart';
import 'package:share_zone/modules/main_module/uploaded_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int myIndex = 3;
  UserController userController = Get.find();
  late ImageController imageController;
  late UserController userController2;
  Future<void> futureFunction() async {
    String? userId =  userController.getLoginUserIdController().value;
    String? name = userController.getUserNameController() as String?;
    String? surname = userController.getUserNameController() as String?;
    print(userId);

    imageController = Get.put(ImageController(), tag: userId);
    userController2 = Get.put(UserController(), tag: userId);
    userController2.setUserIdController(userId);
    userController2.setLoginUserName(name!);
    userController2.setLoginUserName(surname!);
  }

  @override
  Widget build(BuildContext context) {
    print(userController.getLoginUserIdController().value);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: ProfileAppBar(),
      body: Center(
        // Wrap the entire body in a scrollable widget
        child: Column(
          children: [
            // Row widget wrapped with some constraints
            ProfileFollow(),
            ProfileButton(),
            // Ensuring that the next widget is contained and scrollable
            Expanded(child: UploadedPostScreen(isAll: false,)),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(myIndex: myIndex),
    );
  }
}
