


import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:share_zone/modules/loading_widget/build_page_with_future.dart';
import 'package:share_zone/screens/dashboard/dashboard.dart';
import 'package:share_zone/screens/login_screen/login_user.dart';
import 'package:share_zone/screens/notification_screen/notification_screen.dart';
import 'package:share_zone/screens/profile_screen/profile_screen.dart';
import 'package:share_zone/screens/register_screen/add_user.dart';


class RoutesClass{
static String addUser="/addUser";
static String loginUser="/loginUser";
static String  userProfile="/userProfile";
static String  dashboard="/dashboard";
static String  notificationScreen="/notificationScreen";
static String  loadingScreen="/loadingScreen";


static String getScreenAddUser()=>addUser;
static String getLoginScreenAddUser()=>loginUser;
static String getUserProfileScreen()=>userProfile;
static String getDashboardScreen()=>dashboard;
static String getNotificationScreen()=>notificationScreen;
static String getLoadingScreen()=>loadingScreen;

static List<GetPage> routes = [
  GetPage(name: addUser, page: () => AddUser()),
  GetPage(name: loginUser, page: ()=> LoginUser()),
  GetPage(name: userProfile, page: ()=> ProfileScreen()),
  GetPage(name: dashboard, page: ()=> Dashboard()),
  GetPage(name: notificationScreen, page: ()=> NotificationScreen(),),
  GetPage(name: loadingScreen, page: ()=> LoadingScreen(),),

];
}