import 'package:flutter/material.dart';


class CustomAddAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAddAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
    );

  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
