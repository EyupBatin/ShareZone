import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/controller/image_controller.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/repository/token_preferences.dart';

class ApiService {

  /// Token yenileme fonksiyonu
  Future<bool> refreshAccessToken() async {
    final url = Uri.parse('${Ip4Url.baseUrl}/api/refresh_token');
    String? refreshToken = await TokenPreferences().getRefreshToken(); // REFRESH TOKEN AL
    print("Refresh Token: $refreshToken");
    if (refreshToken == null) {
      print("No refresh token found");
      return false;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken'
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String newAccessToken = responseData['access_token'];
        await TokenPreferences().setAccessToken(newAccessToken);
        print("Access token refreshed successfully.");
        return true;
      } else {
        print("Failed to refresh access token: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error refreshing access token: $e");
      return false;
    }

  }

  /// Yetkili API çağrısı yapan fonksiyon
  Future<http.Response> authenticatedPost(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${Ip4Url.baseUrl}/api/$endpoint');
    String? accessToken = await TokenPreferences().getAccessToken();

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 401) {
      bool refreshed = await refreshAccessToken();
      if (refreshed) {
        String? newAccessToken = await TokenPreferences().getAccessToken();
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newAccessToken',
          },
          body: json.encode(body),
        );
      }
    }

    return response;
  }
  static Future<void> fetchProfileImage(String loginUserId,ImageController imageController) async {
    try {
      final response = await http.get(Uri.parse(
        "${Ip4Url.baseUrl}/api/get_profile_image/$loginUserId",
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        imageController.setImageUrl(data["profile_image_base64"]);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  static Future<void> fetchFollowData(String userId,UserController userController) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Ip4Url.baseUrl}/api/get_follows/"
                "${userId}"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userController.setUserFollowersController(data['followers']);
        userController.setUserName(data['name']);
        userController.setUserSurname(data['surname']);
        userController.setUserFollowingController(data['following']);
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }
}
