import 'dart:convert';

import 'package:share_zone/commons/ip4url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TokenPreferences {
  bool _isTokenActive = false;

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh_token");
  }

  Future<void> setRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("refresh_token", token);
  }

  Future<bool> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      return _isTokenActive;
    }
    List<String> parts = token.split('.');
    if (parts.length != 3) {
      _isTokenActive = false;
      return false;
    }
    String payload = utf8
        .decode(base64Url.decode(
        base64Url.normalize(parts[1])));
        Map<String, dynamic > payloadMap = json.decode(payload);
        Map<String, dynamic> decodedPayload = json.decode(payload);
        int exp = decodedPayload['exp'];
        int now = DateTime.now()
        .millisecondsSinceEpoch ~/ 1000;
    if (exp < now) {
      _isTokenActive = false;
      return false;
    } else {
      _isTokenActive = true;
      return true;
    }
    return _isTokenActive;
  }}
