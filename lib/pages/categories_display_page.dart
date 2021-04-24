import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collapsible/collapsible.dart';
import 'package:screenshot/screenshot.dart';

import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/model/model.dart';
import 'package:motivate_linux/services/services.dart';

import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/motivation_app_routes.dart';

class CategoryPageViewPage extends StatefulWidget {
  static final String routeName = "QuoteDisplaPage";

  final CategoriesDisplayPageViewArguments arguments;
  // final String category;

  CategoryPageViewPage({this.arguments});
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
                    .contains(widget.arguments.category.toLowerCase()))
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
            arguments: SingleQuoteViewArguments(
                quote: quotes[index], language: widget.arguments.language),
          );
        });
  }
}

class CategorySingleQuoteView extends StatefulWidget {
  // final Quote quote;

  final SingleQuoteViewArguments arguments;

  CategorySingleQuoteView({this.arguments});
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
  bool langSwitcher = true;
  @override
  void initState() {
    super.initState();
    if (widget.arguments.language.languageCode == "am")
      langSwitcher = false;
    else
      langSwitcher = true;
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/${widget.arguments.quote.id}.jpeg"),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(70),
                        bottomLeft: Radius.circular(70),
                        topLeft: Radius.circular(10)),
                    color: Colors.black54,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 55),
                  width: MediaQuery.of(context).size.width,
                  // height: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        langSwitcher
                            ? widget.arguments.quote.engversion
                            : widget.arguments.quote.amhversion,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            langSwitcher
                                ? widget.arguments.quote.engperson
                                : widget.arguments.quote.amhperson,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.white70),
                            softWrap: true,
                          ),
                        ),
                        onTap: () async {
                          final status = await SearchService().searchAuthor(
                              widget.arguments.quote.engperson, context);
                          if (!status) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  MotivateAppLocalization.of(context)
                                      .getTranslatedValue("no_network"),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
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
                            ShareService().shareQuote(widget.arguments.quote);
                          },
                        ),
                      ),
                      Container(
                        color: Colors.black54,
                        child: BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, state) {
                            if (state is FavoritesLoadSuccess) {
                              final favs = state.quotes;
                              return IconButton(
                                icon: Icon(LikeServce().checkIfLiked(
                                        widget.arguments.quote, favs)
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                                iconSize: 28,
                                color: Colors.white,
                                onPressed: () {
                                  if (LikeServce().checkIfLiked(
                                      widget.arguments.quote, favs)) {
                                    BlocProvider.of<FavoriteBloc>(context).add(
                                        FavoriteDelete(widget.arguments.quote));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          MotivateAppLocalization.of(context)
                                              .getTranslatedValue(
                                                  "remove_from_favs")),
                                    ));
                                  } else {
                                    BlocProvider.of<FavoriteBloc>(context).add(
                                        FavoriteAdd(widget.arguments.quote));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(MotivateAppLocalization.of(
                                              context)
                                          .getTranslatedValue("add_to_favs")),
                                    ));
                                  }
                                },
                              );
                            }
                            return Icon(Icons.favorite_outline);
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
                                              MotivateAppLocalization.of(
                                                      context)
                                                  .getTranslatedValue(
                                                      "screenshot_saved"))));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(MotivateAppLocalization
                                                  .of(context)
                                              .getTranslatedValue(
                                                  "screenshot_not_saved"))));
                                }
                              });
                              _toggleExpand();
                            }),
                      ),
                      Container(
                        color: Colors.black54,
                        child: IconButton(
                            icon: SvgPicture.asset(
                              langSwitcher
                                  ? "assets/svgs/en.svg"
                                  : "assets/svgs/am.svg",
                              width: 25,
                              height: 25,
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
        ),
      ),
    );
  }
}
