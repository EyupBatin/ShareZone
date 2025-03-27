import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  late TextEditingController userName = TextEditingController();
  late TextEditingController userSurname = TextEditingController();
  late TextEditingController userPhone = TextEditingController();
  late TextEditingController userPassword = TextEditingController();
  late TextEditingController userMail = TextEditingController();
  var userName1 = ''.obs;
  var userSurname1 = ''.obs;
  var userLoginName = ''.obs;
  var userLoginSurname = ''.obs;
  var userIsAccepted = 1.obs;
  var userPosts = 0.obs;
  var userId = ''.obs;
  var loginUserId = ''.obs;
  var followersCount = 0.obs;
  var followingCount = 0.obs;
  var filteredUserNames = <dynamic>[].obs;
  var isFollowing = false.obs;
  var accessToken = ''.obs; // accessToken saklamak için
  var listOfRequests = [].obs;
  void setListofRequests(List<Map<String,dynamic>> list) {
    listOfRequests.value = list;
  }
  get getListofRequests => listOfRequests.value;
  void setAccessToken(String token) {
    accessToken.value = token;
  }

  String get getAccessToken => accessToken.value;

  bool get getIsFollowing => isFollowing.value;

  void setIsFollowing(bool followingStatus) {
    isFollowing.value = followingStatus;
  }
  void setUserIsAccepted(int isAccepted) {
    userIsAccepted.value = isAccepted;
  }
  int get getUserIsAccepted => userIsAccepted.value;
  String get getUserName => userName1.value;

  void setUserName(String name) {
    userName1.value = name;
  }

  String get getLoginUserName => userLoginName.value;

  void setLoginUserName(String name) {
    userLoginName.value = name;
  }

  String get getLoginUserSurname => userLoginSurname.value;

  void setLoginSurname(String name) {
    userLoginSurname.value = name;
  }

  String get getUserSurname => userSurname1.value;

  void setUserSurname(String surname) {
    userSurname1.value = surname;
  }

  TextEditingController getUserNameController() {
    return userName;
  }

  TextEditingController getUserSurnameController() {
    return userSurname;
  }

  TextEditingController getUserPhoneController() {
    return userPhone;
  }

  TextEditingController getUserPasswordController() {
    return userPassword;
  }

  TextEditingController getUserMailController() {
    return userMail;
  }

  void setFilteredUserName(List<dynamic> newUserNames) {
    filteredUserNames.value = newUserNames;
  }

  List<dynamic> getFilteredUserName() {
    return filteredUserNames.value;
  }

  void setUserFollowingController(int length) {
    followingCount.value = length;
  }

  RxString getUserIdController() {
    return userId;
  }

  void setUserIdController(String user_id) {
    userId.value = user_id;
  }

  RxString getLoginUserIdController() {
    return loginUserId;
  }

  void setLoginUserIdController(String user_id) {
    loginUserId.value = user_id;
  }

  void setUserPostsController(int length) {
    userPosts.value = length;
  }

  int getUserPostsController() {
    return userPosts.value;
  }

  int getUserFollowersController() {
    return followersCount.value;
  }

  void setUserFollowersController(int length) {
    followersCount.value = length;
  }

  int getUserFollowingController() {
    return followingCount.value;
  }

  void setUsersfollowingController(int length) {
    followingCount.value = length;
  }
}
