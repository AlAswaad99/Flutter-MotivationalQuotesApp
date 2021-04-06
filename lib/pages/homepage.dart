import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/localization/lang_switcher.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/main.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

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
  Uint8List _imageFile;
  int curindex;
  bool _collapsed = false;
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
      child: Screenshot(
        controller: _screenshotController,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imgURL), fit: BoxFit.cover)),
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
                        .getTranslatedValue("title")),
                  ),
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
                              FetchQuoteEvent(
                                  currntIndex: curindex, lang: language));
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
                  // child: Text(MotivateAppLocalization.of(context)
                  //     .getTranslatedValue("title")),
                ),
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                Center(
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
                          onTap: () {
                            setState(() {
                              quotestate.currentIndex = null;
                              index = 0 + rand.nextInt((quotes.length));
                              imgURL = "assets/images/$index.jpeg";
                            });
                          },
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
                                        IconButton(
                                          icon: Icon(Icons.share),
                                          iconSize: 28,
                                          color: Colors.white,
                                          onPressed: () {
                                            Share.share(quotestate.lang == null
                                                ? "${quotes[index].engversion}\n\n${quotes[index].engperson}"
                                                : quotestate.lang
                                                            .languageCode ==
                                                        "am"
                                                    ? "${quotes[index].amhversion}\n\n${quotes[index].amhperson}"
                                                    : "${quotes[index].engversion}\n\n${quotes[index].engperson}");
                                          },
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
                                        SizedBox(
                                          width: 20,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.download_sharp),
                                          iconSize: 28,
                                          color: Colors.white,
                                          onPressed: () {
                                            _saveScreenshot();
                                          },
                                        ),
                                      ],
                                    ),
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
            bottomNavigationBar: Collapsible(
              collapsed: _collapsed,
              axis: CollapsibleAxis.both,
              child: Container(
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
            ),
            //CustomBottomNavigationBar("home"),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
          ),
        ),
      ),
    );
  }

  Future<void> saveScreenshot() async {
    // final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    await _screenshotController.capture().then((value) {
      setState(() {
        _imageFile = value;
      });
    });
    final result =
        await ImageGallerySaver.saveImage(_imageFile, name: fileName);

    print(result);
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _saveScreenshot() async {
    _toggleCollapse();

    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/RPSApp";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(
            directory.path + DateTime.now().microsecondsSinceEpoch.toString());
        await saveScreenshot();

        _toggleExpand();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Screenshot Successfully Saved In Gallery")));

        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        await saveScreenshot();

        return true;
      }
    } catch (e) {
      print(e);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Screenshot Not Saved")));
    return false;
  }
}
