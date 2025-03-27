import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/controller/image_controller.dart';

class PostImages extends StatelessWidget {
  final String? imageBase64;
  PostImages({super.key, this.imageBase64});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      // Allows this widget to take only the needed space
      child: Center(
        child: Image.memory(
          base64Decode(imageBase64!),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
