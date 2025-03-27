import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/screens/post_view/post_view.dart';
import '../../../controller/user_controller.dart';

class OtherUserUploadedPostScreen extends StatelessWidget {
  final RxString userId;
  const OtherUserUploadedPostScreen({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchImages() async {
    int retryCount = 3; // Maximum number of retries
    int attempt = 0;
    while (attempt < retryCount) {
      try {
        final response = await http
            .get(Uri.parse('${Ip4Url.baseUrl}/api/download/${userId.value}'))
            .timeout(Duration(seconds: 2)); // Timeout duration
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          return List<Map<String, dynamic>>.from(jsonData['files']);
        } else {
          print('Failed to load images: ${response.statusCode}');
          return [];
        }
      } catch (e) {
        print('Attempt ${attempt + 1} failed: $e');
        attempt++;
        if (attempt >= retryCount) {
          print('Max retries reached');
          return [];
        }
        await Future.delayed(Duration(seconds: 2)); // Wait before retry
      }
    }
    return [];
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "An error occurred: ${snapshot.error}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textColor),
            ),
          );
        }else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(

              "You don't have any images",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: textColor,
              ),
            ),
          );
        }

        final imageData = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: imageData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(PostView(
                  user_id: userId.value,
                  imageData: imageData,
                  initialIndex: index,
                ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(imageData[index]['base64']),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
