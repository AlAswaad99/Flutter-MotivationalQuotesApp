import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/bloc/favorite_bloc.dart';
import 'package:motivate_linux/services/like_service.dart';
import 'package:motivate_linux/services/share_service.dart';
import 'package:motivate_linux/widgets/custom_background_widget.dart';
import 'package:motivate_linux/widgets/custom_showcase_widget.dart';

class HomeTab extends StatefulWidget {
  final List<GlobalKey> globalkeys;

  HomeTab({this.globalkeys});

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
            index = currentIndex;
          }
          BlocProvider.of<FavoriteBloc>(context).add(FavoritesFetch());
          return CustomBackGroundWidget(
            imgURL: "assets/images/${quotes[index].id}.jpeg",
            child: Center(
              child: GestureDetector(
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
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
                              CustomShowCaseWidget(
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
                              SizedBox(
                                width: 20,
                              ),
                              CustomShowCaseWidget(
                                description: "Add to favorites",
                                globalkey: widget.globalkeys[2],
                                child: BlocBuilder<FavoriteBloc, FavoriteState>(
                                  builder: (context, state) {
                                    if (state is FavoritesLoadSuccess) {
                                      final favs = state.quotes;
                                      return IconButton(
                                        icon: Icon(LikeServce().checkIfLiked(
                                                quotes[index], favs)
                                            ? Icons.favorite
                                            : Icons.favorite_outline),
                                        iconSize: 28,
                                        color: Colors.white,
                                        onPressed: () {
                                          if (LikeServce().checkIfLiked(
                                              quotes[index], favs)) {
                                            BlocProvider.of<FavoriteBloc>(
                                                    context)
                                                .add(FavoriteDelete(
                                                    quotes[index]));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Removed From Favorites"),
                                            ));
                                          } else {
                                            BlocProvider.of<FavoriteBloc>(
                                                    context)
                                                .add(
                                                    FavoriteAdd(quotes[index]));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Added to Favorites"),
                                            ));
                                          }
                                        },
                                      );
                                    }
                                    return Icon(Icons.favorite_outline);
                                  },
                                ),
                              ),
                            ],
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
    );
  }
}
