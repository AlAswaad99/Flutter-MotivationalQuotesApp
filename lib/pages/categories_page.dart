import 'package:flutter/material.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/categories.dart';
import 'package:motivate_linux/model/language.dart';

class CategoriesPage extends StatefulWidget {
  Language currentLang;
  CategoriesPage({this.currentLang});
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 35.0,
            children: List.generate(categories.length, (index) {
              return Center(child: _buildCategoriesCards(categories[index]));
            })),
      ),
    );
  }

  Widget _buildCategoriesCards(Category cat) {
    return Card(
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
        ));
  }
}
