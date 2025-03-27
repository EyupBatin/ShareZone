import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/commons/firebase_api.dart';
import 'package:share_zone/commons/get_device_type.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:share_zone/repository/token_preferences.dart';
import 'package:share_zone/screens/dashboard/dashboard.dart';
import 'dart:convert';

import 'package:share_zone/screens/login_screen/widgets/login_image.dart';
import 'package:share_zone/services/api_service.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final TextEditingController _phoneOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  final UserController loginUserController = Get.find();

  Future<void> loginUserFunc(String phoneOrEmail, String password) async {
    final url = Uri.parse('${Ip4Url.baseUrl}/api/login');

    String? phoneNumber;
    String? email;
    if (phoneOrEmail.contains('@')) {
      email = phoneOrEmail;
    } else {
      phoneNumber = phoneOrEmail;
    }

    final data = {
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      'password': password,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.authenticatedPost('login', data);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Login successful: ${responseData['message']}');

        loginUserController
            .setLoginUserIdController(responseData['user_id'].toString());

        String accessToken = responseData['access_token'];
        String refreshToken = responseData['refresh_token'];
        print("Access Token: $accessToken");
        print("Refresh Token: $refreshToken");
        loginUserController.setAccessToken(accessToken);
        await TokenPreferences().setAccessToken(accessToken);
        await TokenPreferences().setRefreshToken(refreshToken);

        await FirebaseMessaging.instance.deleteToken();
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        print("Yeni FCM Token: $fcmToken");

        if (fcmToken != null) {
          String deviceType = await getDeviceType(); // Fetch the device type
          // Check if a token for this device_type exists in the database

          // If token does not exist for this device type, save the new token
          await FirebaseApi().sendTokenToServer(fcmToken);
        }

        setState(() {
          _isLoading = false;
          _errorMessage = '';
          Get.offAll(() => const Dashboard());
        });
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _isLoading = false;
          _errorMessage = responseData['error'];
        });
        print('Error: ${responseData['error']}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
      print('Login error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LoginImage(),
              TextField(
                controller: _phoneOrEmailController,
                decoration: InputDecoration(
                  labelText: 'Phone or Email',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                ),
              ),
              SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        loginUserFunc(
                          _phoneOrEmailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                      child: Text('Login'),
                    ),
              SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
