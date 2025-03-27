import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_zone/controller/image_controller.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/routes/routes.dart';
import 'package:share_zone/utils/utils.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 📌 GetX Controller'larını başlat
  Get.put(UserController());
  Get.put(ImageController());

  // 📌 Firebase Bildirimlerini Dinle
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  setupFirebaseMessaging();
  WidgetsBinding.instance.addPostFrameCallback((_)async{
    await getInitialMessage();
  });

  // 📌 Cihazı sadece dikey moda sabitle
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: RoutesClass.loadingScreen,
    navigatorKey: navigatorKey,
    getPages: RoutesClass.routes,
  ));
}
