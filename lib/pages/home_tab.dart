import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/bloc/favorite_bloc.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/services/like_service.dart';
import 'package:motivate_linux/services/share_service.dart';
import 'package:motivate_linux/widgets/custom_background_widget.dart';
import 'package:motivate_linux/widgets/custom_showcase_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';

class HomeTab extends StatefulWidget {
  final List<GlobalKey> globalkeys;
  final Language currentLang;

  HomeTab({this.globalkeys, this.currentLang});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int currentIndex;
  int index;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
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
          if (quotestate.indexChanged == null ||
              quotestate.indexChanged == true) {
            index = 0 + Random().nextInt((quotes.length));
          } else {
            if (currentIndex == null)
              index = 0 + Random().nextInt((quotes.length));
            else
              index = currentIndex;
          }
          BlocProvider.of<FavoriteBloc>(context).add(FavoritesFetch());
          return CustomBackGroundWidget(
            imgURL: "assets/images/${quotes[index].id}.jpeg",
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0 + Random().nextInt((quotes.length));
                        currentIndex = index;
                      });
                    },
                    child: CustomShowCaseWidget(
                      description: "tap on quote to change",
                      globalkey: widget.globalkeys[0],
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
                        // color: Colors.black38,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.currentLang == null
                                  ? quotes[index].engversion
                                  : widget.currentLang.languageCode == "am"
                                      ? quotes[index].amhversion
                                      : quotes[index].engversion,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              child: Text(
                                widget.currentLang == null
                                    ? quotes[index].engperson
                                    : widget.currentLang.languageCode == "am"
                                        ? quotes[index].amhperson
                                        : quotes[index].engperson,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white54),
                                softWrap: true,
                              ),
                              onTap: () async =>
                                  searchDude(quotes[index].engperson, context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15))),
                        // color: Colors.black54,
                        child: CustomShowCaseWidget(
                          description: "share quotes",
                          globalkey: widget.globalkeys[1],
                          child: IconButton(
                            icon: Icon(Icons.share),
                            iconSize: 28,
                            color: Colors.white,
                            onPressed: () {
                              ShareService().shareQuote(quotes[index]);
                            },
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black54,
                      ),
                      Container(
                        color: Colors.black54,
                        child: CustomShowCaseWidget(
                          description: "Add to favorites",
                          globalkey: widget.globalkeys[2],
                          child: BlocBuilder<FavoriteBloc, FavoriteState>(
                            builder: (context, state) {
                              if (state is FavoritesLoadSuccess) {
                                final favs = state.quotes;
                                return IconButton(
                                  icon: Icon(LikeServce()
                                          .checkIfLiked(quotes[index], favs)
                                      ? Icons.favorite
                                      : Icons.favorite_outline),
                                  iconSize: 28,
                                  color: Colors.white,
                                  onPressed: () {
                                    if (LikeServce()
                                        .checkIfLiked(quotes[index], favs)) {
                                      BlocProvider.of<FavoriteBloc>(context)
                                          .add(FavoriteDelete(quotes[index]));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            MotivateAppLocalization.of(context)
                                                .getTranslatedValue(
                                                    "remove_from_favs")),
                                      ));
                                    } else {
                                      BlocProvider.of<FavoriteBloc>(context)
                                          .add(FavoriteAdd(quotes[index]));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            MotivateAppLocalization.of(context)
                                                .getTranslatedValue(
                                                    "add_to_favs")),
                                      ));
                                    }
                                  },
                                );
                              }
                              return Icon(Icons.favorite_outline);
                            },
                          ),
                        ),
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
    );
  }

  void searchDude(String person, BuildContext context) async {
    String _url = "https://www.google.com/search?q=";
    String _queryString = person.replaceAll(" ", "+");
    // String query = Uri.encodeQueryComponent(_queryString);
    // String uri = Uri.encodeFull(_url + query);
    var uri = Uri.parse(_url + _queryString).toString();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      // await canLaunch(uri)
      await launch(
        uri,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No Network")));
    }
  }
}
