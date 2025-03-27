import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';

class AddUserMail extends StatelessWidget {
  final UserController userController = Get.find();
  final _formKey = GlobalKey<FormState>();

  AddUserMail({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _validateEmail(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Eğer e-posta geçerli ise başka işlemler yapılabilir
      _showSnackbar(context, "Geçerli e-posta!");
    } else {
      // Geçersiz e-posta mesajı
      _showSnackbar(context, "Geçersiz e-posta adresi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Form(
        key: _formKey,
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
          child: TextFormField(
            controller: userController.userMail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Mail',
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen e-posta adresinizi giriniz';
              }
              // Basit bir e-posta doğrulama regex'i
              String pattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return 'Geçerli bir e-posta adresi giriniz';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
