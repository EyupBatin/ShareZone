import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/user_controller.dart';


class AddUserSurname extends StatelessWidget {
  AddUserSurname({super.key});
  final UserController userController =Get.find();
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
          controller: userController.userSurname,
          decoration: InputDecoration(
            hintText: 'Surname',
            border: InputBorder.none,
          ),
        ),

      ),

    );
  }
}
