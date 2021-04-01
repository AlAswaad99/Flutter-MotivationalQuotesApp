import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/model/quotes.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "HomePage";
  final String title;

  HomePage({this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String jsonUrl = "assets/jsons/quotes.json";

  @override
  void initState() {
    super.initState();
    // listOfQuotes = QuoteDataProvider().fetchQuotes(jsonUrl);
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
    return drawHomePage(tabController, _onWillPop, widget.title);
  }

  Widget drawHomePage(
      TabController tabController, Function _onWillPop, String title) {
    Random rand = Random();
    int index;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/1.jpeg"), fit: BoxFit.cover)),
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.2),
            actions: [
              IconButton(
                icon: Icon(Icons.public),
                onPressed: () {},
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
                        index = 0 + rand.nextInt((quotes.length));
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              index = 0 + rand.nextInt((quotes.length));
                            });
                          },
                          child: Container(
                            // decoration: const BoxDecoration(
                            //   image: DecorationImage(
                            //       image: AssetImage("assets/images/1.jpeg"),
                            //       fit: BoxFit.cover),
                            // ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  quotes[index].engversion,
                                  textAlign: TextAlign.center,
                                  // lisOfQuotes[0].engversion,
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.white),
                                  softWrap: true,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  quotes[index].engperson,
                                  textAlign: TextAlign.right,
                                  // lisOfQuotes[0].engversion,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70),
                                  softWrap: true,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      iconSize: 25,
                                      color: Colors.white,
                                      onPressed: () {},
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.favorite_outline),
                                      iconSize: 25,
                                      color: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ],
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
            color: const Color.fromRGBO(255, 255, 255, 0.1),
            child: TabBar(
              indicatorColor: Colors.black45,
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
