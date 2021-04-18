import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivate_linux/pages/favorites_tab.dart';
import 'package:motivate_linux/pages/homepage.dart';
import 'package:motivate_linux/pages/favorite_display_page.dart';
import 'package:motivate_linux/pages/quotes_by_categories_display_page.dart';

class MotivationAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => HomePage());
    }
    if (settings.name == FavoritedQuoteDisplayPage.routeName) {
      final quote = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => FavoritedQuoteDisplayPage(
                quote: quote,
              ));
    }
    if (settings.name == CategoryPageViewPage.routeName) {
      final category = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => CategoryPageViewPage(
                category: category,
              ));
    }
    return MaterialPageRoute(builder: (context) => HomePage());
  }
}
