import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/firebase_api.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/services/isAcceptedFunctions.dart';
import 'package:share_zone/constants/color.dart';
import 'dart:convert';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/utils/utils.dart';

class FollowButton extends StatefulWidget {
  final RxString userId;

  const FollowButton({super.key, required this.userId});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isLoading = false;
  UserController loginUserController = Get.find();
  late UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Get.put(UserController(),tag: widget.userId.value);
    userController.setUserIdController(widget.userId.value);
  }

  Future<void> _loadFollowStatus() async {
    String? accessToken = await TokenPreferences().getAccessToken();
    final url = Uri.parse('${Ip4Url.baseUrl}/api/check_follow');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'follower_id': userController.getUserIdController().value,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userController.setIsFollowing(data['is_following']);
    }
  }

  Future<void> sendRequestUser() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));


      FirebaseApi firebaseApi = FirebaseApi();

      await firebaseApi
          .sendNotification(userController.getUserIdController().value);
      await isAcceptedUpdate(2,true);

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() => isLoading = false);
  }

  Future<void> unfollowUser() async {
    String? accessToken = await TokenPreferences().getAccessToken();
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.parse('${Ip4Url.baseUrl}/api/unfollow');
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
      await isAcceptedUpdate(1,true);
      await Future.delayed(Duration(milliseconds: 500));
      userController.setIsFollowing(false);

      setState(() {
        isLoading = false;
        fetchFollowData();
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchFollowData() async {
    try {
      final response = await http.get(
        Uri.parse("${Ip4Url.baseUrl}/api/get_follows/"
            "${userController.getUserIdController()}"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userController.setUserFollowersController(data['followers']);
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  Future<void> futureFunction() async {
    await _loadFollowStatus();
    int accepted = await isAcceptedGet(userController);
    userController.setUserIsAccepted(accepted);
    print(userController.getUserIsAccepted);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Obx(
          ()=>Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : userController.getUserIsAccepted == 3
                        ? unfollowUser
                        : userController.getUserIsAccepted == 2
                            ? null
                            : sendRequestUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: userController.getIsFollowing ||
                          userController.getUserIsAccepted == 1
                      ? followBttn
                      : userController.getUserIsAccepted == 3
                          ? Colors.grey
                          : followBttn,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        userController.getIsFollowing &&
                                userController.getUserIsAccepted == 3
                            ? 'Unfollow'
                            : userController.getUserIsAccepted == 2
                                ? 'Follow Request Sent'
                                : 'Follow',
                        style: const TextStyle(
                          color: textColor,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
