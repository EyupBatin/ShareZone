import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/firebase_api.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'dart:convert';

import 'package:share_zone/screens/login_screen/login_user.dart';

class AddUserButton extends StatelessWidget {
  final UserController userController = Get.find();

  AddUserButton({super.key});

  Future<void> sendUserDataToApi() async {
    final String apiUrl = "${Ip4Url.baseUrl}/api/register";

    // Firebase FCM token'ı al
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      Get.snackbar(
        "Error",
        "Failed to retrieve FCM token.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Map<String, dynamic> userData = {
      "name": userController.userName.text,
      "surname": userController.userSurname.text,
      "phone_number": userController.userPhone.text,
      "password": userController.userPassword.text,
      "email": userController.userMail.text,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        // Kullanıcı başarıyla kaydedildi, şimdi FCM token'ı gönder
        FirebaseApi().sendTokenToServer(fcmToken);

        Get.snackbar(
          "Success",
          "User registered successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(()=>LoginUser());
      } else {
        final responseData = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          responseData["error"] ?? "Failed to register user.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: sendUserDataToApi,
      child: const Text("Register"),
    );
  }
}
