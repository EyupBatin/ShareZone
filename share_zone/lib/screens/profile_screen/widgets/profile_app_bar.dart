import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/get_device_type.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/routes/routes.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  ProfileAppBar({super.key});

  // Updated logout function
  Future<void> logoutFunction() async {
    String device_type = await getDeviceType(); // Get the device type
    var body = jsonEncode({
      "device_type": device_type, // Prepare request body
    });

    try {
      // Get the access token asynchronously
      String? token = await TokenPreferences().getAccessToken();
      if (token == null || token.isEmpty) {
        // Handle case if no token is found
        print("No access token found");
        return;
      }

      // Make the POST request to logout
      final response = await http.post(
        Uri.parse("${Ip4Url.baseUrl}/api/logout"),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include token in headers
        },
      );

      if (response.statusCode == 200) {
        // If logout is successful, clear tokens and navigate to loading screen
        await TokenPreferences().setAccessToken('');
        await TokenPreferences().setRefreshToken('');
        Get.toNamed(RoutesClass.loadingScreen); // Navigate to the loading screen
        print("Token preferences cleared.");
      } else {
        // Handle unsuccessful logout response
        print("Failed to logout: ${response.body}");
      }
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: zonePink,
      automaticallyImplyLeading: false,
      title: const Text(
        "ShareZone",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Crimson",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(1000, 80, 0, 0),
              items: [
                PopupMenuItem(
                  value: "settings",
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Settings"),
                      Icon(Icons.settings)
                    ],
                  ),
                  onTap: () {
                    // Add settings action here
                  },
                ),
                PopupMenuItem(
                  value: "logout",
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logout"),
                      Icon(Icons.logout),
                    ],
                  ),
                  onTap: logoutFunction, // Call logout when tapped
                ),
              ],
            );
          },
          icon: Icon(Icons.menu_outlined),
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
