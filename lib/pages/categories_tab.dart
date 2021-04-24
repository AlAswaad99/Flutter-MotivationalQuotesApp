import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:motivate_linux/model/model.dart';

import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/motivation_app_routes.dart';
import 'package:motivate_linux/pages/categories_display_page.dart';

class CategoriesTab extends StatefulWidget {
  final Language currentLang;
  final List<GlobalKey> globalkeys;

  CategoriesTab({this.currentLang, this.globalkeys});
  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List<Category> categories = <Category>[
    Category(title: 'personal', image: 'assets/svgs/personal.svg'),
    Category(title: 'time', image: 'assets/svgs/time.svg'),
    Category(title: 'leadership', image: 'assets/svgs/leadership.svg'),
    Category(title: 'speaking', image: 'assets/svgs/speaking.svg'),
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
            return Column(
              children: [
                GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      quoteCard(categories[index]),
                      quoteThumbnail(categories[index]),
                    ],
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                      CategoryPageViewPage.routeName,
                      arguments: CategoriesDisplayPageViewArguments(
                          category: categories[index].title,
                          language: widget.currentLang)),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          },
        ),
        // children: [_buildCategoriesCardsLeft(cat, index)],
      ),
    );
  }

  Widget quoteThumbnail(Category cat) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.symmetric(vertical: 12.0),
      alignment: FractionalOffset.centerLeft,
      height: 92.0,
      width: 92.0,
      child: SvgPicture.asset(cat.image),
    );
  }

  Widget quoteCard(Category cat) {
    return Container(
      height: 124.0,
      margin: EdgeInsets.only(left: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 65),
            child: Text(
              MotivateAppLocalization.of(context).getTranslatedValue(cat.title),
              softWrap: true,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
