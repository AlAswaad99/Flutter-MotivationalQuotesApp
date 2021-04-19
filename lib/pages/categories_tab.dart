import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/categories.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/pages/categories_display_page.dart';

class CategoriesTab extends StatefulWidget {
  final Language currentLang;
  CategoriesTab({this.currentLang});
  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List<Category> categories = <Category>[
    Category(title: 'personal', image: 'assets/images/personal.jpg'),
    Category(title: 'time', image: 'assets/images/time.png'),
    Category(title: 'leadership', image: 'assets/images/leader.jpg'),
    Category(title: 'speaking', image: 'assets/images/speaking.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),

        children: List.generate(
          categories.length,
          (index) {
            return Center(
                child: index % 2 == 0
                    ? _buildCategoriesCardsLeft(categories[index], index)
                    : _buildCategoriesCardsRight(categories[index], index));
          },
        ),
        // children: [_buildCategoriesCardsLeft(cat, index)],
      ),
    );
  }

  Widget _buildCategoriesCardsLeft(Category cat, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 50),
      title: Row(
        children: [
          Text(
            MotivateAppLocalization.of(context).getTranslatedValue(cat.title),
            softWrap: false,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            Emojis.chartIncreasing,
          ),
        ],
      ),
      leading: Container(
        height: 250,
        width: 100,
        child: Image(
          image: AssetImage(cat.image),
        ),
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(CategoryPageViewPage.routeName, arguments: cat.title),
    );
  }

  Widget _buildCategoriesCardsRight(Category cat, int index) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 50),
      title: Row(
        children: [
          Text(
            MotivateAppLocalization.of(context).getTranslatedValue(cat.title),
            softWrap: false,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            Emojis.chartIncreasing,
          ),
        ],
      ),
      trailing: Container(
        height: 250,
        width: 100,
        child: Image(
          image: AssetImage(cat.image),
        ),
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(CategoryPageViewPage.routeName, arguments: cat.title),
    );
  }
}
