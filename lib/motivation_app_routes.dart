import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:motivate_linux/pages/favorites_tab.dart';
import 'package:motivate_linux/pages/homepage.dart';
import 'package:motivate_linux/pages/favorite_display_page.dart';
import 'package:motivate_linux/pages/categories_display_page.dart';

class MotivationAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => HomePage());
    }
    if (settings.name == FavoritedQuoteDisplayPage.routeName) {
      final arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => FavoritedQuoteDisplayPage(
                arguments: arguments,
              ));
    }
    if (settings.name == CategoryPageViewPage.routeName) {
      final arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => CategoryPageViewPage(
                arguments: arguments,
              ));
    }
    return MaterialPageRoute(builder: (context) => HomePage());
  }
}

class FavoritesDisplayPageArguments {
  final Quote quote;
  final Language language;
  FavoritesDisplayPageArguments({this.quote, this.language});
}

class SingleQuoteViewArguments {
  final Quote quote;
  final Language language;
  SingleQuoteViewArguments({this.quote, this.language});
}

class CategoriesDisplayPageViewArguments {
  final String category;
  final Language language;
  CategoriesDisplayPageViewArguments({this.category, this.language});
}
