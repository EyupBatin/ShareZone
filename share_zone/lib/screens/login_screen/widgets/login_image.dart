import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0, 120, 0, 15),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/share_zone.jpeg'),
        radius: 50.0,
      ),
    );
  }
}
