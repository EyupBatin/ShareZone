import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/modules/main_module/user_image.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/services/isAcceptedFunctions.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  UserController userController = Get.find();

  Future<void> followAccept(String followingId) async {
    print(followingId);
    String? accessToken = await TokenPreferences().getAccessToken();
    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse('${Ip4Url.baseUrl}/api/follow');
    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'following_id': followingId,
      }),
    );
    userController.setUserIdController(followingId);
  }

  void removeFromRequestList(String Id) {
    userController.getListofRequests
        .removeWhere((request) => request['id'].toString() == Id);
    userController.listOfRequests.refresh();
  }

  // İlk veri yükleme işlemi
  Future<void> fetchData() async {
    await notAcceptedRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
      body: FutureBuilder<void>(
        future: fetchData(), // İlk veri yükleme
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Obx(() {
            var listOfRequests = userController.getListofRequests;

            if (listOfRequests.isEmpty) {
              return const Center(
                child: Text(
                  "No notification data available",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: listOfRequests.length,
              itemBuilder: (context, index) {
                String userName =
                    "${listOfRequests[index]['name']} ${listOfRequests[index]['surname']}";
                String followingId = listOfRequests[index]['id'].toString();
                print(followingId);
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        SizedBox(child: UserImage(user_id: followingId, isBig: false,)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            userName,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                followAccept(followingId);
                                print("Takip isteği onaylandı!");
                                removeFromRequestList(followingId);
                              },
                              child: const Text("Onayla"),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                userController.setUserIdController(followingId);
                                isAcceptedUpdate(1, false);
                                removeFromRequestList(followingId);
                                print("Takip isteği reddedildi!");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Sil"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
