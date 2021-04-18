import 'package:flutter/material.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/categories.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/pages/quotes_by_categories_display_page.dart';

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
      body: Center(
        child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            crossAxisCount: 1,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 35.0,
            children: List.generate(categories.length, (index) {
              return Center(
                  child: _buildCategoriesCards(categories[index], index));
            })),
      ),
    );
  }

  Widget _buildCategoriesCards(Category cat, int index) {
    return GestureDetector(
      child: Card(
        elevation: 0,
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Image(image: AssetImage(cat.image))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    MotivateAppLocalization.of(context)
                        .getTranslatedValue(cat.title),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ]),
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
          CategoryPageViewPage.routeName,
          arguments: categories[index].title),
    );
  }
}
