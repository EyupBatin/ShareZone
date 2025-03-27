import 'dart:convert';

import 'package:get/get.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/repository/token_preferences.dart';

import '../commons/ip4url.dart';
import 'package:http/http.dart' as http;

Future<void> isAcceptedUpdate(int isAccepted,bool whichUser) async {
  UserController userController = Get.find();
  print(userController.getUserIdController().value);

  try {
    final url = Uri.parse('${Ip4Url.baseUrl}/api/is_accepted_update');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await TokenPreferences().getAccessToken()}',
      },
      body: jsonEncode({
        'is_accepted': isAccepted,
        'follower_id': userController.getUserIdController().value,
        'which_user': whichUser,
      }),
    );

    if (response.statusCode == 200) {
      print("is accepted updated");
    }
  } catch (e) {
    print(e);
  }
}

Future<int> isAcceptedGet(UserController userController) async {
  try {
    String userId = userController.getUserIdController().value;

    final response = await http.get(
      Uri.parse('${Ip4Url.baseUrl}/api/is_accepted_get/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await TokenPreferences().getAccessToken()}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['is_accepted'] ?? 1;
    }
  } catch (e) {
    print("Bağlantı hatası: $e");
  }

  return 1; // Hata durumunda varsayılan değer döndür
}


Future<List<Map<String, dynamic>>> notAcceptedRequest() async {
  String? accessToken = await TokenPreferences().getAccessToken();
  print("access token: $accessToken");

  RxList<Map<String, dynamic>> listofRequests = <Map<String, dynamic>>[].obs; // Başlat
  UserController userController = Get.find();

  try {
    final response = await http.get(
      Uri.parse('${Ip4Url.baseUrl}/api/not_accepted_requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      listofRequests.assignAll(data['requests'].map<Map<String, dynamic>>((request) {
        return {
          'id': request['id'],
          'name': request['name'],
          'surname': request['surname'],
        };
      }).toList());

      userController.setListofRequests(listofRequests);
    }
  } catch (e) {
    print("Bağlantı hatası: $e");
  }

  return listofRequests.toList(); // Listeyi List<Map<String, dynamic>> olarak döndür
}

