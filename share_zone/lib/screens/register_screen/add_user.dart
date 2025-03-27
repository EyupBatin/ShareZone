// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import 'widgets/add_user_button.dart';
import 'widgets/add_user_mail.dart';
import 'widgets/add_user_name.dart';
import 'widgets/add_user_password.dart';
import 'widgets/add_user_phone.dart';
import 'widgets/add_user_surname.dart';
import 'widgets/custom_add_app_bar.dart';
class AddUser extends StatelessWidget {
  AddUser({super.key});

  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAddAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 90),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Ekran yüksekliğine göre sınır koyduk
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // İçeriğe göre boyutlanmasını sağladık
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    AddUserName(),
                    const SizedBox(width: 16),
                    AddUserSurname(),
                  ],
                ),
              ),
              AddUserMail(),
              AddUserPhone(),
              AddUserPassword(),
              AddUserButton(),
            ],
          ),
        ),
      ),
    );
  }
}
