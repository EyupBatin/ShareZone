import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/image_controller.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/screens/post_view/widgets/post_images.dart';
import 'package:share_zone/screens/post_view/widgets/post_usages_bar.dart';
import 'package:share_zone/screens/post_view/widgets/post_user_view.dart';

class PostView extends StatefulWidget {
  final String user_id;
  final List<Map<String, dynamic>> imageData; // Base64 ve user_id içerir
  final int initialIndex;

  const PostView({
    Key? key,
    required this.user_id,
    required this.imageData,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  ImageController imageController= Get.find<ImageController>();



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: barColor,
        title: const Text(
          "Post View",
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.imageData.length,
        itemBuilder: (context, index) {
          final imageBase64 = widget.imageData[index]['base64'];
          final userId =
              widget.user_id; // Kullanıcı ID'si

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Ensures Column takes only the space it needs
              children: [
                // Kullanıcı Bilgisi
                PostUserView(user_id: userId),
                PostImages(imageBase64: imageBase64,),
                PostUsagesBar(),
              ],
            ),
          );
        },
      ),
    );
  }
}
