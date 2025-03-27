import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/controller/image_controller.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/repository/token_preferences.dart';

class ProfileButton extends StatelessWidget {
  ProfileButton({super.key});

  final ImageController imageController = Get.find();
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.red,
      onPressed: _pickImageFromGallery,
      child: const Text(
        "Profile Action",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;

    // Resmi ImageController'a kaydet
    imageController.setSelectedImage(File(returnedImage.path));

    // Resmi sunucuya yükle
    await _uploadImageToServer();
  }

  Future<void> _uploadImageToServer() async {
    if (imageController.getSelectedImage() == null) return;

    File imageFile = imageController.getSelectedImage()!;
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes); // Convert to Base64

      var response = await http.post(
        Uri.parse("${Ip4Url.baseUrl}/api/upload_profile_image"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await TokenPreferences().getAccessToken()}",
        },
        body: jsonEncode({
          "image": base64Image, // Send the base64 string
        }),
      );

      if (response.statusCode == 200) {
        print("Image uploaded successfully");
        fetchProfileImage();
      } else {
        print("Failed to upload image: ${response.body}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> fetchProfileImage() async {
    String loginUserId = userController.getLoginUserIdController().value;
    try {
      final response = await http.get(Uri.parse(
        "${Ip4Url.baseUrl}/api/get_profile_image/$loginUserId",
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String base64Image = data["profile_image_base64"];

        // Store the base64 image string in the ImageController
        imageController.setImageUrl(base64Image);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection error: $e");
    }
  }
}
