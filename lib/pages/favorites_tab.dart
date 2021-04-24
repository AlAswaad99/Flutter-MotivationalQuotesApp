import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/model/model.dart';

import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/motivation_app_routes.dart';
import 'package:motivate_linux/pages/favorite_display_page.dart';
import 'package:emojis/emojis.dart';

class FavoritesTab extends StatefulWidget {
  static final String routeName = "FavoritesPage";

  final Language currentLang;

  FavoritesTab({this.currentLang});

  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  Quote undoQuote;
  final GlobalKey<ScaffoldState> _containerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _containerKey,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favoritestate) {
          if (favoritestate is FavoriteOperationFailure) {
            return Center(
                child: Text(
              'Could not do Favorite operation',
              style: TextStyle(color: Colors.redAccent),
            ));
          }
          if (favoritestate is FavoritesLoadSuccess) {
            final favorites = favoritestate.quotes;
            if (favorites.length == 0) {
              return Center(
                  child: Text(MotivateAppLocalization.of(context)
                      .getTranslatedValue("no_favs")));
            }
            return _buildfavoriteslist(favorites, context);
          }

          return Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget _buildfavoriteslist(List<Quote> favorites, BuildContext ctx) {
    return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    widget.currentLang == null
                        ? "${favorites[index].engperson} ${Emojis.redHeart}"
                        : widget.currentLang.languageCode == "am"
                            ? "${favorites[index].amhperson} ${Emojis.redHeart}"
                            : "${favorites[index].engperson} ${Emojis.redHeart}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                widget.currentLang == null
                    ? "${favorites[index].engversion}"
                    : widget.currentLang.languageCode == "am"
                        ? "${favorites[index].amhversion}"
                        : "${favorites[index].engversion}",
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  undoQuote = favorites[index];
                  BlocProvider.of<FavoriteBloc>(context)
                      .add(FavoriteDelete(favorites[index]));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(MotivateAppLocalization.of(context)
                        .getTranslatedValue("remove_from_favs")),
                    duration: const Duration(milliseconds: 6000),
                    action: SnackBarAction(
                      label: MotivateAppLocalization.of(context)
                          .getTranslatedValue("undo"),
                      onPressed: () {
                        BlocProvider.of<FavoriteBloc>(ctx)
                            .add(FavoriteAdd(undoQuote));
                      },
                    ),
                  ));
                },
              ),
              onTap: () => Navigator.of(context).pushNamed(
                  FavoritedQuoteDisplayPage.routeName,
                  arguments: FavoritesDisplayPageArguments(
                      quote: favorites[index], language: widget.currentLang)),
            ),
          );
        });
  }
}
