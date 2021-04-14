import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/bloc/favorite_bloc.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:motivate_linux/pages/favorite_display_page.dart';
import 'package:collapsible/collapsible.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class CategoryPageViewPage extends StatefulWidget {
  static final String routeName = "QuoteDisplaPage";

  final String category;

  CategoryPageViewPage({this.category});
  @override
  _CategoryPageViewPageState createState() => _CategoryPageViewPageState();
}

class _CategoryPageViewPageState extends State<CategoryPageViewPage> {
  @override
  Widget build(BuildContext context) {
    List<Quote> quotes;
    return Scaffold(
      body: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (context, quotestate) {
          if (quotestate is QuoteOperationFailure) {
            return Center(
                child: Text(
              'Could not fetch quote from JSON',
              style: TextStyle(color: Colors.redAccent),
            ));
          }
          if (quotestate is QuoteLoadSuccessful) {
            quotes = quotestate.quotes
                .where((quote) => quote.engcategory
                    .toLowerCase()
                    .contains(widget.category.toLowerCase()))
                .toList();
          }
          return Center(child: _buildQuoteDisplay(quotes));
        },
      ),
    );
  }

  Widget _buildQuoteDisplay(List<Quote> quotes) {
    if (quotes.length == 0) {
      return Center(
        child: Text("No Quotes in category"),
      );
    }
    return PageView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return CategorySingleQuoteView(
            quote: quotes[index],
          );
        });
  }
}

class CategorySingleQuoteView extends StatefulWidget {
  final Quote quote;
  CategorySingleQuoteView({this.quote});
  @override
  _CategorySingleQuoteViewState createState() =>
      _CategorySingleQuoteViewState();
}

class _CategorySingleQuoteViewState extends State<CategorySingleQuoteView> {
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
  Uint8List _imageFile;
  bool langSwitcher = true;

  @override
  Widget build(BuildContext context) {
    return Screenshot(
        controller: _screenshotController,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/${widget.quote.id}.jpeg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
              body: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  // height: 200,
                  color: Colors.black38,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        langSwitcher
                            ? widget.quote.engversion
                            : widget.quote.amhversion,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        langSwitcher
                            ? widget.quote.engperson
                            : widget.quote.amhperson,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Collapsible(
                        collapsed: _collapsed,
                        axis: CollapsibleAxis.both,
                        duration: const Duration(milliseconds: 50),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.share),
                                iconSize: 28,
                                color: Colors.white,
                                onPressed: () {
                                  Share.share(
                                      "${widget.quote.engversion}\n\n${widget.quote.engperson}\n\n\n${widget.quote.amhversion}\n\n${widget.quote.amhperson}");
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              BlocBuilder<FavoriteBloc, FavoriteState>(
                                builder: (context, state) {
                                  if (state is FavoritesLoadSuccess) {
                                    final favs = state.quotes;
                                    return IconButton(
                                      icon: Icon(
                                          checkIfLiked(widget.quote, favs)
                                              ? Icons.favorite
                                              : Icons.favorite_outline),
                                      iconSize: 28,
                                      color: Colors.white,
                                      onPressed: () {
                                        if (checkIfLiked(widget.quote, favs)) {
                                          BlocProvider.of<FavoriteBloc>(context)
                                              .add(
                                                  FavoriteDelete(widget.quote));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Removed From Favorites"),
                                          ));
                                        } else {
                                          BlocProvider.of<FavoriteBloc>(context)
                                              .add(FavoriteAdd(widget.quote));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Added to Favorites"),
                                          ));
                                        }
                                      },
                                    );
                                  }
                                  return Icon(Icons.favorite_outline);
                                },
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
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  icon: Image(
                                    image: AssetImage(langSwitcher
                                        ? "assets/images/en.png"
                                        : "assets/images/am.png"),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      langSwitcher = !langSwitcher;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
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
        // Future.delayed(
        //   const Duration(milliseconds: 100),
        // );
        // await saveScreenshot();

        return true;
      }
    } catch (e) {
      print(e);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Screenshot Not Saved")));
    _toggleExpand();
    return false;
  }

  bool checkIfLiked(Quote quote, List<Quote> favs) {
    for (var item in favs) {
      if (quote.id == item.id) {
        return true;
      }
    }
    return false;
  }
}
