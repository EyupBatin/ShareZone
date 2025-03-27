import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/modules/main_module/my_navigation_bar.dart';
import 'package:share_zone/modules/main_module/uploaded_post_screen.dart';
import 'package:share_zone/screens/exploration_screen/explorations_widgets/exploration_app_bar.dart';
import 'package:share_zone/screens/exploration_screen/explorations_widgets/searchBox.dart';

class ExplorationPhotosScreen extends StatelessWidget {
  const ExplorationPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ExplorationAppBar(isSearching: false,),
      backgroundColor: bgColor,
      body: Column(children: [
        SearchBox(isSearching: false,),
        Expanded(child: UploadedPostScreen(isAll: true,)),
      ]),
      bottomNavigationBar: MyNavigationBar(myIndex: 1,),
    );
  }
}
