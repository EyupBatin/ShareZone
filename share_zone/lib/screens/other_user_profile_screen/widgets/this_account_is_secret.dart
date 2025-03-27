import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_zone/constants/color.dart';

class ThisAccountIsSecret extends StatelessWidget {
  const ThisAccountIsSecret({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20,),
      child: Row(

        children: [
          Icon(
            CupertinoIcons.lock_circle_fill,
            color: textColor,
            size: 56.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                textAlign: TextAlign.left,
                "This account is secret",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,

                ),
              ),
              Text(
                "İf u want to see this account, you need to follow",
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
