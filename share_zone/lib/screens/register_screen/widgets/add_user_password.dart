import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';

class AddUserPassword extends StatelessWidget {
  AddUserPassword({super.key});
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: userController.userPassword,
          decoration: InputDecoration(
            hintText: 'Password',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
