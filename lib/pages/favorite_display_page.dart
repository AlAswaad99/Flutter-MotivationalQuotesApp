import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:motivate_linux/services/screenshot_service.dart';
import 'package:motivate_linux/services/share_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class FavoritedQuoteDisplayPage extends StatefulWidget {
  static final String routeName = "QuoteDisplayPage";
  final Quote quote;
  FavoritedQuoteDisplayPage({this.quote});
  @override
  _FavoritedQuoteDisplayPageState createState() =>
      _FavoritedQuoteDisplayPageState();
}

class _FavoritedQuoteDisplayPageState extends State<FavoritedQuoteDisplayPage> {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70),
                              bottomLeft: Radius.circular(70),
                              topLeft: Radius.circular(10)),
                          color: Colors.black54,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 55),
                        width: MediaQuery.of(context).size.width,
                        // height: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              langSwitcher
                                  ? widget.quote.engversion
                                  : widget.quote.amhversion,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
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
                          ],
                        ),
                      ),
                    ),
                    Collapsible(
                      collapsed: _collapsed,
                      axis: CollapsibleAxis.both,
                      duration: const Duration(milliseconds: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15))),
                            child: IconButton(
                              icon: Icon(Icons.share),
                              iconSize: 28,
                              color: Colors.white,
                              onPressed: () {
                                ShareService().shareQuote(widget.quote);
                              },
                            ),
                          ),
                          Container(
                            color: Colors.black54,
                            child: IconButton(
                              icon: Icon(Icons.download_sharp),
                              iconSize: 28,
                              color: Colors.white,
                              onPressed: () async {
                                _toggleCollapse();
                                await ScreenshotService()
                                    .saveScreenshot(_screenshotController)
                                    .then((value) {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Screenshot Successfully Saved In Gallery")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Screenshot Not Saved")));
                                  }
                                });
                                _toggleExpand();
                              },
                            ),
                          ),
                          Container(
                            color: Colors.black54,
                            child: IconButton(
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
