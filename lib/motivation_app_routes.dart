import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivate_linux/pages/favorites_list_page.dart';
import 'package:motivate_linux/pages/homepage.dart';
import 'package:motivate_linux/pages/favorite_display_page.dart';

class MotivationAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => HomePage());
    }
    if (settings.name == DisplayQuotesPage.routeName) {
      final quote = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => DisplayQuotesPage(
                quote: quote,
              ));
    }
  }
}
