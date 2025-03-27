import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/screens/notification_screen/notification_screen.dart';

import 'get_device_type.dart';
import 'ip4url.dart';

class FirebaseApi {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  UserController userController = Get.find();

  Future<void> sendTokenToServer(String fcmToken) async {
    String deviceType = await getDeviceType();
    await analytics.logEvent(
      name: 'fcm_token_saved',
      parameters: {'token': fcmToken},
    );
    String? accessToken = await TokenPreferences().getAccessToken();

    if (accessToken == null) {
      print("Hata: Kullanıcı giriş yapmamış!");
      return;
    }

    var url = Uri.parse("${Ip4Url.baseUrl}/api/save_token");
    var body = jsonEncode({
      "fcm_token": fcmToken,
      "device_type": deviceType,
    });

    print("Gönderilen JSON: $body");

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: body,
    );

    if (response.statusCode == 201) {
      print("Token başarıyla kaydedildi!");
    } else {
      print("Hata: ${response.body}");
    }
  }


  Future<void> sendNotification(String userId) async {
    await analytics.logEvent(
      name: 'notification_sent',
      parameters: {'title': "Takip İsteği"},
    );
    String? accessToken = await TokenPreferences().getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      print("Hata: JWT Token boş veya null!");
      return;
    }
    String username = '${userController
        .getLoginUserName} '
        '${userController
        .getLoginUserSurname}';
    const String apiUrl =
        "${Ip4Url.baseUrl}/api/send_notification"; // Flask API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${accessToken.trim()}",
      },
      body: jsonEncode({
        "title": "Takip İsteği",
        "body": "$username seni takip etmek istiyor!",
        "click_action": "FLUTTER_NOTIFICATION_CLICK", // Bildirime tıklanınca yönlendirme yapılmasını sağlar
        "screen": "/notificationScreen",
        "target_user_id": userId,
      }),

    );

    if (response.statusCode == 200) {
      print("Bildirim başarıyla gönderildi!");
    } else {
      print("Bildirim gönderme başarısız: ${response.body}");
    }
  }
  void setupFirebaseMessaging() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Bildirim tıklandı! Veriler: ${message.data}");

      if (message.data.containsKey('screen')) {
        String targetScreen = message.data['screen'];
        String? messageBody = message.data['body'];
        if (targetScreen == "/notificationScreen") {
          Get.toNamed('/notificationScreen',arguments: message); // GetX ile yönlendirme
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && message.data.containsKey('screen')) {
        String targetScreen = message.data['screen'];
        String messageBody = message.data['body'];
        if (targetScreen == "/notificationScreen") {
          Get.toNamed('/notificationScreen',arguments: message); // Uygulama kapalıyken açıldığında yönlendir
        }
      }
    });
  }
}

// Future<void> initNotification() async {
//   await _firebaseMessaging.requestPermission();
//   final fcmToken = await _firebaseMessaging.getToken();
//   print("FCM Token: $fcmToken");
//
//   initPushNotification();
// }
// void handleNotification(RemoteMessage message) {
//   if(message.notification != null) {
//     Get.to(
//       NotificationScreen(),
//       arguments: message,
//     );
//   }
//   else{
//     return;
//   }
// }
//
// Future<void> initPushNotification() async {
//   FirebaseMessaging.instance.getInitialMessage().then((message) {
//     if (message != null) {
//       handleNotification(message);
//     }
//   });
//
//   FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
// }
