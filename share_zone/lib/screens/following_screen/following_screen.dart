import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/screens/other_user_profile_screen/other_user_profile_screen.dart';

class FollowingScreen extends StatefulWidget {
  final RxString user_id;

  const FollowingScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  late UserController userController;
  List followers = [];

  @override
  void initState() {
    super.initState();
    userController = Get.put(
      UserController(),
      tag: widget.user_id.value,
    );
    userController.setUserIdController(widget.user_id.value);
    fetchUserFollowingData();
  }

  Future<void> fetchUserFollowingData() async {
    try {
      print("${userController.getUserIdController()}");

      final response = await http.get(
        Uri.parse("${Ip4Url.baseUrl}/api/get_followings/"
            "${userController.getUserIdController()}"),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          followers = data['following'].map((follower) {
            return {
              'id': follower['id'],
              'name': follower['name'],
              'surname': follower['surname'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Takip Ettiklerim'),
      ),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          var following = followers[index];
          return Card(
            margin: EdgeInsets.all(5.0),
            color: Colors.white,
            child: ListTile(
              title: Text(
                  '${followers[index]['name']} ${followers[index]['surname']}'),
              onTap: () {
                String selectedId = following['id'].toString();
                userController.setUserIdController(selectedId);
                Get.to(
                  OtherUserProfileScreen(
                    user_id: userController.getUserIdController(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
