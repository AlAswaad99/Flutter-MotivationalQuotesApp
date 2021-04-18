import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/bloc/favorite_bloc.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/localization/lang_switcher.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/main.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:motivate_linux/pages/categories_page.dart';
import 'package:motivate_linux/pages/favorites_list_page.dart';
import 'package:motivate_linux/services/like_service.dart';
import 'package:motivate_linux/widgets/custom_background_widget.dart';
import 'package:motivate_linux/widgets/custom_showcase_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "/";
  final BuildContext context;

  HomePage({this.context});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  final List<String> paths = [
    "title",
    "favs",
    "cats",
  ];
  String currentpath;

  String jsonUrl = "assets/jsons/quotes.json";
  String langIconURL = "assets/images/en.png";
  String imgURL = "assets/images/1.jpeg";

  Language currentLang;
  Uint8List _imageFile;
  int curindex;
  bool _collapsed = false;

  final _keyOne = GlobalKey();
  final _keyTwo = GlobalKey();
  final _keyThree = GlobalKey();
  final _keyFour = GlobalKey();
  final _keyFive = GlobalKey();

  void _toggleCollapse() {
    setState(() {
      _collapsed = true;
    });
  }

  void _toggleExpand() {
    setState(() {
      _collapsed = false;
    });
  }

  ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    currentpath = paths[0];
    super.initState();

    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabController.addListener(changepath);
  }

  void changepath() {
    setState(() {
      currentpath = paths[tabController.index];
    });
  }

  Future<bool> _onWillPop() async {
    if (tabController.index != 0) {
      tabController.index = 0;
      return null;
    }
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit this App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
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
        ShowCaseWidget.of(context)
            .startShowCase([_keyOne, _keyTwo, _keyThree, _keyFour, _keyFive]);
      }
    });

    return drawHomePage(tabController, _onWillPop);
  }

  Widget drawHomePage(TabController tabController, Function _onWillPop) {
    Random rand = Random();
    int index;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Screenshot(
        controller: _screenshotController,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Collapsible(
              collapsed: _collapsed,
              axis: CollapsibleAxis.both,
              child: AppBar(
                title: Collapsible(
                  collapsed: _collapsed,
                  axis: CollapsibleAxis.both,
                  child: Text(MotivateAppLocalization.of(context)
                      .getTranslatedValue(currentpath)),
                ),
                backgroundColor: Colors.black38,
                actions: [
                  CustomShowCaseWidget(
                    description: "change language Englis/Amharic",
                    globalkey: _keyFour,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 20.0, 8.0),
                      child: DropdownButton<Language>(
                        elevation: 0,
                        // dropdownColor: Colors.white10,
                        icon: Image(
                          image: AssetImage(langIconURL),
                          width: 25,
                          height: 25,
                        ),
                        underline: SizedBox(),
                        onChanged: (Language language) {
                          MotivateApp.setLocale(
                              context, LanguageSwitch.changeLanguage(language));
                          curindex = index;
                          BlocProvider.of<QuoteBloc>(context).add(
                              FetchQuoteEvent(
                                  currntIndex: curindex, lang: language));
                          setState(() {
                            langIconURL =
                                "assets/images/${language.languageCode}.png";
                            currentLang = language;
                          });
                        },
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                              (e) => DropdownMenuItem<Language>(
                                value: e,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          "assets/images/${e.languageCode}.png"),
                                      width: 20,
                                      height: 20,
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
                // child: Text(MotivateAppLocalization.of(context)
                //     .getTranslatedValue("title")),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, quotestate) {
                  if (quotestate is QuoteOperationFailure) {
                    return Center(
                        child: Text(
                      'Could not fetch quote from JSON',
                      style: TextStyle(color: Colors.redAccent),
                    ));
                  }
                  if (quotestate is QuoteLoadSuccessful) {
                    final quotes = quotestate.quotes;
                    if (quotestate.currentIndex == null) {
                      index = 0 + rand.nextInt((quotes.length));
                    } else {
                      index = quotestate.currentIndex;
                    }
                    BlocProvider.of<FavoriteBloc>(context)
                        .add(FavoritesFetch());
                    return CustomBackGroundWidget(
                      imgURL: "assets/images/${quotes[index].id}.jpeg",
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              quotestate.currentIndex = null;
                              index = 0 + rand.nextInt((quotes.length));
                            });
                          },
                          child: CustomShowCaseWidget(
                            description: "tap on quote to change",
                            globalkey: _keyOne,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              width: MediaQuery.of(context).size.width,
                              // height: 200,
                              color: Colors.black38,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    quotestate.lang == null
                                        ? quotes[index].engversion
                                        : quotestate.lang.languageCode == "am"
                                            ? quotes[index].amhversion
                                            : quotes[index].engversion,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                    softWrap: true,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    quotestate.lang == null
                                        ? quotes[index].engperson
                                        : quotestate.lang.languageCode == "am"
                                            ? quotes[index].amhperson
                                            : quotes[index].engperson,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white70),
                                    softWrap: true,
                                  ),
                                  Collapsible(
                                    collapsed: _collapsed,
                                    axis: CollapsibleAxis.both,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomShowCaseWidget(
                                            description: "share quotes",
                                            globalkey: _keyTwo,
                                            child: IconButton(
                                              icon: Icon(Icons.share),
                                              iconSize: 28,
                                              color: Colors.white,
                                              onPressed: () {
                                                Share.share(quotestate.lang ==
                                                        null
                                                    ? "${quotes[index].engversion}\n\n${quotes[index].engperson}"
                                                    : quotestate.lang
                                                                .languageCode ==
                                                            "am"
                                                        ? "${quotes[index].amhversion}\n\n${quotes[index].amhperson}"
                                                        : "${quotes[index].engversion}\n\n${quotes[index].engperson}");
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          CustomShowCaseWidget(
                                            description:
                                                "like/Add to favorites",
                                            globalkey: _keyThree,
                                            child: BlocBuilder<FavoriteBloc,
                                                FavoriteState>(
                                              builder: (context, state) {
                                                if (state
                                                    is FavoritesLoadSuccess) {
                                                  final favs = state.quotes;
                                                  return IconButton(
                                                    icon: Icon(LikeServce()
                                                            .checkIfLiked(
                                                                quotes[index],
                                                                favs)
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline),
                                                    iconSize: 28,
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      if (LikeServce()
                                                          .checkIfLiked(
                                                              quotes[index],
                                                              favs)) {
                                                        BlocProvider.of<
                                                                    FavoriteBloc>(
                                                                context)
                                                            .add(FavoriteDelete(
                                                                quotes[index]));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Removed From Favorites"),
                                                        ));
                                                      } else {
                                                        BlocProvider.of<
                                                                    FavoriteBloc>(
                                                                context)
                                                            .add(FavoriteAdd(
                                                                quotes[index]));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Added to Favorites"),
                                                        ));
                                                      }
                                                    },
                                                  );
                                                }
                                                return Icon(
                                                    Icons.favorite_outline);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),

              // MoviesListPage(),
              FavoritesPage(currentLang: currentLang),
              //QuoteListTrial(),
              CategoriesPage(
                currentLang: currentLang,
              ),
            ],
          ),

/*
              Container(
                color: const Color(0xffdedede),
                child: Center(
                  child: Text("Home",
                    style: TextStyle(
                        fontSize: 72.0
                    ),),
                ),
              ),
*/
          bottomNavigationBar: Collapsible(
            collapsed: _collapsed,
            axis: CollapsibleAxis.both,
            child: Container(
              color: Colors.black38,
              child: TabBar(
                indicatorColor: Colors.white70,
                controller: tabController,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.format_quote,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.favorite,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.info,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //CustomBottomNavigationBar("home"),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
        ),
      ),
    );
  }
}
