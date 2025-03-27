import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/image_controller.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/modules/main_module/my_navigation_bar.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/screens/other_user_profile_screen/widgets/follow_button.dart';
import 'package:share_zone/screens/other_user_profile_screen/widgets/other_profile_follow.dart';
import 'package:share_zone/screens/other_user_profile_screen/widgets/other_user_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/screens/other_user_profile_screen/widgets/other_user_uploaded_post_screen.dart';
import 'package:share_zone/screens/other_user_profile_screen/widgets/this_account_is_secret.dart';
import 'package:share_zone/services/api_service.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final RxString user_id;

  const OtherUserProfileScreen({super.key, required this.user_id});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  late UserController userController;
  late ImageController imageController;

  Future<void> checkFollowingStatus() async {
    String? accessToken = await TokenPreferences().getAccessToken();
    final url = Uri.parse('${Ip4Url.baseUrl}/api/check_follow');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'following_id': userController.getUserIdController().value,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userController.setIsFollowing(data['is_following']);
    }
  }

  Future<void> futureFunction() async {
    imageController = Get.put(ImageController(), tag: widget.user_id.value);
    userController = Get.put(UserController(), tag: widget.user_id.value);
    userController.setUserIdController(widget.user_id.value);
    checkFollowingStatus();
    ApiService.fetchFollowData(
        userController.getUserIdController().value, userController);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading profile"));
        }
        return Scaffold(
          backgroundColor: bgColor,
          appBar: OtherUserAppBar(),
          body: Column(
            children: [
              OtherProfileFollow(user_id: widget.user_id),
              FollowButton(userId: widget.user_id),
              Obx(() {
                if (userController.getIsFollowing &&
                    userController.getUserIsAccepted == 3) {
                  return Expanded(
                      child:
                          OtherUserUploadedPostScreen(userId: widget.user_id));
                } else {
                  return ThisAccountIsSecret();
                }
              }),
            ],
          ),
          bottomNavigationBar: MyNavigationBar(myIndex: 1),
        );
      },
    );
  }
}
