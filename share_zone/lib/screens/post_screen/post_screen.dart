import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/modules/main_module/my_navigation_bar.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/screens/post_screen/widgets/gallery_slider_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final UserController userController = Get.find();

  File? _image;
  int myIndex = 2;
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    String? accessToken=await TokenPreferences().getAccessToken();
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image selected!")));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Ip4Url.baseUrl}/api/upload'),
      );
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print(response.statusCode);
      if (response.statusCode == 201) {
        var jsonResponse = json.decode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Upload successful! File: ${jsonResponse['file_path']}")),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Upload failed!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Callback method to update selected image
  void _updateSelectedImage(File image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height - 600);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ShareZone",
          style: TextStyle(
            color: textColor,
            fontFamily: "Crimson",
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: zonePink,
      ),
      bottomNavigationBar: MyNavigationBar(myIndex: myIndex),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        color: textColor,
        child: Stack(
          children: [

            // Display the selected image if available
            _image != null
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height - 600,
                    child: InteractiveViewer(
                      child: Container(

                        color: textColor,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                : Positioned.fill(
                    child: Container(
                      color: textColor,
                      alignment: Alignment.center,
                      child: const Text("No image selected"),
                    ),
                  ),
            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Container(
                color: bgColor,
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _isUploading ? null : _uploadImage,
                      icon: _isUploading
                          ? const CircularProgressIndicator()
                          : const Icon(
                              CupertinoIcons.add_circled_solid,
                              color: textColor,
                            ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.camera_fill,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child:
                    GallerySliderScreen(onImageSelected: _updateSelectedImage)),
          ],
        ),
      ),
    );
  }
}
