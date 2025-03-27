import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:http/http.dart' as http;
Future<List<String>> getFcmTokens(
    RxString targetUserId, String accessToken) async {
  final url =
  Uri.parse("${Ip4Url.baseUrl}/api/get_fcm_token/${targetUserId.value}");

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $accessToken", // JWT Token ekle
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<String>.from(data['fcm_tokens']); // Token listesini döndür
  } else {
    throw Exception("Failed to fetch FCM tokens: ${response.body}");
  }
}
Future<void> getInitialMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null && initialMessage.data.containsKey('screen')) {
    String targetScreen = initialMessage.data['screen'];
    String messageBody = initialMessage.data['body'];
    Get.toNamed(targetScreen,arguments: messageBody);
  }
}
/// 📌 Bildirime tıklandığında yönlendirme yapar
void setupFirebaseMessaging() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🟢 Bildirime tıklandı: ${message.data}");
    String? messageBody = message.data['body'];
    if (message.data.containsKey('screen')) {
      String targetScreen = message.data['screen'];
      Get.toNamed(targetScreen,arguments: messageBody);
    }
  });
}
/// 📌 Arka planda bildirim alındığında çalışır
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔵 Arka planda bildirim alındı: ${message.data}");
}

