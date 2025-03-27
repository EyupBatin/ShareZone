import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/screens/other_user_profile_screen/other_user_profile_screen.dart';


class FollowerScreen extends StatefulWidget {
  final RxString user_id;
  const FollowerScreen({
    required this.user_id,
    Key? key,
  }) : super(key: key);
  @override
  _FollowerScreenState createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  List followers = [];
  late UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Get.put(UserController(), tag: widget.user_id.value);
    userController.setUserIdController(widget.user_id.value);
    fetchUserFollowersData();
  }
  Future<void> fetchUserFollowersData() async {
    try {
      print("${userController.getUserIdController()}");
      final response = await http.get(
        Uri.parse("${Ip4Url.baseUrl}/api/get_followers/"
            "${userController.getUserIdController()}"),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          followers = data['followers'].map((follower) {
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
        title: Text("My followers"),
        backgroundColor: zonePink,
      ),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          var follower = followers[index];
          return Card(
            margin: EdgeInsets.all(5.0),
            color: Colors.white,
            child: ListTile(
              title: Text("${follower['name']} ${follower['surname']}"),
              onTap: () {
                String selectedId = follower['id'].toString();
                userController.setUserIdController(selectedId);
                Get.to(() => OtherUserProfileScreen(
                      user_id: userController.getUserIdController(),
                    ));
              },
            ),
          );
        },
      ),
    );
  }
}
