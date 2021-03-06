import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/model/model.dart';
import 'package:motivate_linux/widgets/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motivate_linux/localization/lang_switcher.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/main.dart';
import 'package:motivate_linux/pages/categories_tab.dart';
import 'package:motivate_linux/pages/favorites_tab.dart';
import 'package:motivate_linux/pages/home_tab.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "/";
  final Language language;

  HomePage({this.language});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomePage> {
  TabController tabController;

  final List<String> paths = [
    "favs",
    "title",
    "cats",
  ];
  String currentpath;

  String jsonUrl = "assets/jsons/quotes.json";
  String langIconURL = "assets/svgs/en.svg";
  String imgURL = "assets/images/1.jpeg";

  Language currentLang;
  int curindex;

  final _keyOne = GlobalKey();
  final _keyTwo = GlobalKey();
  final _keyThree = GlobalKey();
  final _keyFour = GlobalKey();
  final _keyFive = GlobalKey();
  final _keySix = GlobalKey();

  // void _toggleCollapse() {
  //   setState(() {
  //     _collapsed = true;
  //   });
  // }

  // void _toggleExpand() {
  //   setState(() {
  //     _collapsed = false;
  //   });
  // }

  ScreenshotController _screenshotController = ScreenshotController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    currentpath = paths[1];
    super.initState();

    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    tabController.addListener(changepath);

    if (widget.language != null) {
      currentLang = widget.language;
      langIconURL = "assets/svgs/${widget.language.languageCode}.svg";
    }
  }

  void changepath() {
    setState(() {
      currentpath = paths[tabController.index];
    });
  }

  Future<bool> _onWillPop() async {
    if (tabController.index != 1) {
      tabController.index = 1;
      return null;
    }
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(MotivateAppLocalization.of(context)
                .getTranslatedValue("are_you_sure")),
            content: Text(MotivateAppLocalization.of(context)
                .getTranslatedValue("exit_message")),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(MotivateAppLocalization.of(context)
                    .getTranslatedValue("no")),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(MotivateAppLocalization.of(context)
                    .getTranslatedValue("yes")),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SharedPreferences preferences;
    displayShowCase() async {
      preferences = await SharedPreferences.getInstance();
      bool showCaseVisisbilityStatus = preferences.getBool("displayShowCase");

      if (showCaseVisisbilityStatus == null) {
        preferences.setBool("displayShowCase", false);
        return true;
      }
      return false;
    }

    displayShowCase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([
          _keyOne,
          _keyTwo,
          _keyThree,
          _keyFour,
          _keyFive,
          _keySix,
        ]);
      }
    });

    return drawHomePage(tabController, _onWillPop);
  }

  Widget drawHomePage(TabController tabController, Function _onWillPop) {
    bool indexChanged;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Screenshot(
        controller: _screenshotController,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              MotivateAppLocalization.of(context)
                  .getTranslatedValue(currentpath),
              style: TextStyle(fontFamily: 'Geogrotesque-Bold'),
            ),
            backgroundColor: const Color.fromRGBO(11, 11, 11, 1),
            actions: [
              CustomShowCaseWidget(
                description: "Switch Language Between English/????????????",
                globalkey: _keyFive,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 25.0, 8.0),
                  child: DropdownButton<Language>(
                    elevation: 0,
                    // dropdownColor: Colors.white10,
                    icon: SvgPicture.asset(
                      langIconURL,
                      width: 15,
                      height: 15,
                    ),

                    underline: SizedBox(),
                    onChanged: (Language language) {
                      MotivateApp.setLocale(
                          context, LanguageSwitch.changeLanguage(language));
                      indexChanged = false;
                      BlocProvider.of<QuoteBloc>(context).add(FetchQuoteEvent(
                          indexChanged: indexChanged, lang: language));
                      setCurrentLanguage(language.languageCode);
                      setState(() {
                        langIconURL =
                            "assets/svgs/${language.languageCode}.svg";
                        currentLang = language;
                        indexChanged = true;
                      });
                    },
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>(
                          (e) => DropdownMenuItem<Language>(
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/svgs/${e.languageCode}.svg",
                                  width: 15,
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  e.name,
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            ],
          ),
          body: Container(
            child: TabBarView(
              controller: tabController,
              children: [
                FavoritesTab(currentLang: currentLang),
                HomeTab(
                  currentLang: currentLang,
                  globalkeys: [_keyOne, _keyTwo, _keyThree, _keyFour],
                ),
                CategoriesTab(
                  currentLang: currentLang,
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(tabController: tabController),
          backgroundColor: const Color.fromRGBO(11, 11, 11, 1),
          extendBody: true,
        ),
      ),
    );
  }

  void setCurrentLanguage(String languageCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("currentLocale", languageCode);
  }
}
