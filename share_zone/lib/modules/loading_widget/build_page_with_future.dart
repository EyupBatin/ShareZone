import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/screens/dashboard/dashboard.dart';
import 'package:share_zone/screens/login_screen/login_user.dart';
import 'package:share_zone/services/api_service.dart';

class LoadingScreen extends StatelessWidget {
  final ApiService _apiService = ApiService(); // ApiService örneği oluşturduk.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: _checkAndRefreshToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.offAll(() =>
                      snapshot.data! ? const Dashboard() : const LoginUser());
                });
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  /// Access token'ı kontrol eder, gerekirse refresh token ile yeniler.
  Future<bool> _checkAndRefreshToken() async {
    bool isTokenActive = await TokenPreferences().checkToken();

    if (!isTokenActive) {
      print("object");
      // Eğer access token geçersizse, ApiService üzerinden token yenilemeyi dene
      bool refreshed = await _apiService.refreshAccessToken();
      if (refreshed) {
        return true; // Yeni token alındıysa giriş yapabiliriz
      }
    }
    return isTokenActive; // Eğer token geçerliyse veya yenileme başarısızsa durumu döndür
  }
}
