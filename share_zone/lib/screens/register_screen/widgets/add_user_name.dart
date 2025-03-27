import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/user_controller.dart';

class AddUserName extends StatelessWidget {
  AddUserName({super.key});
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          controller: userController.userName,
          decoration: InputDecoration(
            hintText: 'Name',
            border: InputBorder.none,
          ),
        ),

      ),

    );
  }
}
