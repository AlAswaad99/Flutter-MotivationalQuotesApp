import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/categories.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/motivation_app_routes.dart';
import 'package:motivate_linux/pages/categories_display_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                      planetCard(categories[index]),
                      planetThumbnail(categories[index]),
                    ],
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                      CategoryPageViewPage.routeName,
                      arguments: CategoriesDisplayPageViewArguments(
                          category: categories[index].title,
                          language: widget.currentLang)),
                ),

                // index % 2 == 0
                // _buildCategoriesCardsLeft(categories[index], index),
                // : _buildCategoriesCardsRight(categories[index], index),
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

  // Widget _buildCategoriesCardsLeft(Category cat, int index) {
  //   return GestureDetector(
  //     child: Container(
  //       padding: EdgeInsets.only(left: 10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           SvgPicture.asset(
  //             cat.image,
  //             height: 100,
  //           ),
  //           SizedBox(
  //             width: 20,
  //           ),
  //           Container(
  //             child: Text(
  //               MotivateAppLocalization.of(context)
  //                   .getTranslatedValue(cat.title),
  //               softWrap: true,
  //               style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     onTap: () => Navigator.of(context)
  //         .pushNamed(CategoryPageViewPage.routeName, arguments: cat.title),
  //   );
  // }

  // Widget _buildCategoriesCardsRight(Category cat, int index) {
  //   return GestureDetector(
  //     child: Container(
  //       padding: EdgeInsets.only(right: 20),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Text(
  //             MotivateAppLocalization.of(context).getTranslatedValue(cat.title),
  //             softWrap: false,
  //             style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
  //           ),
  //           SizedBox(
  //             width: 20,
  //           ),
  //           SvgPicture.asset(
  //             cat.image,
  //             height: 100,
  //           ),
  //         ],
  //       ),
  //     ),
  //     onTap: () => Navigator.of(context)
  //         .pushNamed(CategoryPageViewPage.routeName, arguments: cat.title),
  //   );
  // }

  Widget planetThumbnail(Category cat) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.symmetric(vertical: 12.0),
      alignment: FractionalOffset.centerLeft,
      height: 92.0,
      width: 92.0,
      child: SvgPicture.asset(cat.image),
    );
  }

  Widget planetCard(Category cat) {
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

// class CategoryRow extends StatelessWidget {
//   final String imgURL;
//   CategoryRow(this.imgURL);
//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//         height: 120.0,
//         margin: const EdgeInsets.symmetric(
//           vertical: 16.0,
//           horizontal: 24.0,
//         ),
//         child: new Stack(
//           children: <Widget>[
//             planetCard,
//             planetThumbnail,
//           ],
//         ));
//   }

//   final planetThumbnail = new Container(
//     margin: new EdgeInsets.symmetric(vertical: 16.0),
//     alignment: FractionalOffset.centerLeft,
//     height: 92.0,
//     width: 92.0,
//     // child: SvgPicture.asset(assetName),
//   );

//   final planetCard = new Container(
//     height: 124.0,
//     margin: new EdgeInsets.only(left: 46.0),
//     decoration: new BoxDecoration(
//       shape: BoxShape.rectangle,
//       borderRadius: new BorderRadius.circular(8.0),
//       boxShadow: <BoxShadow>[
//         new BoxShadow(
//           color: Colors.black12,
//           blurRadius: 10.0,
//           offset: new Offset(0.0, 10.0),
//         ),
//       ],
//     ),
//   );
// }
