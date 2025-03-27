import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<String> getDeviceType() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    return "Web";
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return "Android (${androidInfo.model})"; // Cihaz modelini de ekleyebilirsin
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return "iOS (${iosInfo.utsname.machine})";
  } else {
    return "Unknown";
  }
}
