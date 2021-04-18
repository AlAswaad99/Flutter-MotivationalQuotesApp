import 'package:flutter/material.dart';

class CustomBackGroundWidget extends StatelessWidget {
  final String imgURL;
  final Widget child;

  CustomBackGroundWidget({this.imgURL, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imgURL), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
