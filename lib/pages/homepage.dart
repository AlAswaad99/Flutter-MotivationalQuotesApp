import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/localization/lang_switcher.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/main.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/model/quotes.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String jsonUrl = "assets/jsons/quotes.json";
  String langIconURL = "assets/images/en.png";
  String imgURL = "assets/images/1.jpeg";

  int curindex;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              FlatButton(
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
    return drawHomePage(
      tabController,
      _onWillPop,
    );
  }

  Widget drawHomePage(
    TabController tabController,
    Function _onWillPop,
  ) {
    Random rand = Random();
    int index;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(imgURL), fit: BoxFit.cover)),
        child: Scaffold(
          appBar: AppBar(
            title: Text(MotivateAppLocalization.of(context)
                .getTranslatedValue("title")),
            backgroundColor: Colors.white10,
            actions: [
              Padding(
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
                        FetchQuoteEvent(currntIndex: curindex, lang: language));
                    setState(() {
                      langIconURL =
                          "assets/images/${language.languageCode}.png";
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
              )
            ],
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Center(
                child: Container(
                  child: BlocBuilder<QuoteBloc, QuoteState>(
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
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              quotestate.currentIndex = null;
                              index = 0 + rand.nextInt((quotes.length));
                              imgURL = "assets/images/$index.jpeg";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 230,
                            color: Colors.black38,
                            child: Column(
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
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.share),
                                        iconSize: 28,
                                        color: Colors.white,
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite_outline),
                                        iconSize: 28,
                                        color: Colors.white,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),

              // MoviesListPage(),
              Center(
                child: Text(
                  "Favorites",
                  style: TextStyle(fontSize: 72.0),
                ),
              ),
              //QuoteListTrial(),
              Center(
                child: Text(
                  "About Us",
                  style: TextStyle(fontSize: 72.0),
                ),
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
          bottomNavigationBar: Container(
            color: const Color.fromRGBO(255, 255, 255, 0),
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
          //CustomBottomNavigationBar("home"),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
        ),
      ),
    );
  }
}
