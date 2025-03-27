import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/screens/dashboard/widgets/dashboard_app_bar.dart';
import 'package:share_zone/modules/main_module/my_navigation_bar.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  initState() {
    super.initState();
    fetchLoginUserData();
  }

  int myIndex = 0;
  UserController userController = Get.find();

  Future<void> fetchLoginUserData() async {
    try {
      String? accessToken = await TokenPreferences().getAccessToken();
      final response = await http.get(
        Uri.parse("${Ip4Url.baseUrl}/api/dashboard"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userController.setLoginUserName(data['name']);
        userController.setLoginSurname(data['surname']);
        userController.setLoginUserIdController(data['user_id']);
      } else {
        print("Dashboard Response: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const DashboardAppBar(),
      bottomNavigationBar: MyNavigationBar(myIndex: myIndex),
    );
  }
}
