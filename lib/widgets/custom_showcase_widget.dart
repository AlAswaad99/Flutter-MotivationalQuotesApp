import 'package:flutter/material.dart';
import 'package:showcaseview/showcase.dart';

class CustomShowCaseWidget extends StatelessWidget {
  final Widget child;
  final GlobalKey globalkey;
  final String description;

  CustomShowCaseWidget({this.child, this.globalkey, this.description});

  @override
  Widget build(BuildContext context) {
    return Showcase(key: globalkey, description: description, child: child);
  }
}
