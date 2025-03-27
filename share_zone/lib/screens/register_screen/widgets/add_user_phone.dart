import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';

class AddUserPhone extends StatelessWidget {
  UserController userController = Get.find();
  AddUserPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
          controller: userController.userPhone,
          decoration: InputDecoration(
            hintText: 'Phone',
            border: InputBorder.none,
          ),
        ),

      ),
    );
  }
}
