import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/screens/dashboard/dashboard.dart';
import 'package:share_zone/screens/exploration_screen/exploration_people_screen/exploration_screen.dart';
import 'package:share_zone/screens/exploration_screen/exploration_photos_screen/exploration_photos_screen.dart';
import 'package:share_zone/screens/post_screen/post_screen.dart';
import 'package:share_zone/screens/profile_screen/profile_screen.dart';

class MyNavigationBar extends StatefulWidget {
  final int
      myIndex; // Değişkeni final yap, setState içinde değiştirmeye çalışmayacağız.

  const MyNavigationBar({super.key, required this.myIndex});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int selectedIndex = 0; // State içinde güncellenecek index

  @override
  void initState() {
    super.initState();
    selectedIndex =
        widget.myIndex; // Başlangıç değerini dışarıdan alınan index yap
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index; // Güncelleme işlemi burada yapılmalı
    });

    // Seçilen index'e göre yönlendirme
    switch (index) {
      case 0:
        Get.to(() => const Dashboard());
        break;

      case 1:
        Get.to(() => const ExplorationPhotosScreen());
        break;

      case 2:
        Get.to(() => const PostScreen());
        break;

      case 3:
        Get.to(() => const ProfileScreen()); // Profile sayfasına yönlendir
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedIndex, // Güncellenen index
      onTap: _onItemTapped, // OnTap fonksiyonunu bağladık
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
          backgroundColor: barColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.compass),
          label: 'Explore',
          backgroundColor: barColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.arrow_down_to_line),
          label: 'Post',
          backgroundColor: barColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_alt_circle),
          label: 'Profile',
          backgroundColor: barColor,
        ),
      ],
    );
  }
}
