import 'dart:convert';
import 'dart:math';
// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:motivate_linux/dataprovider/favorite_data.dart';
import 'package:motivate_linux/model/quotes.dart';

class QuoteDataProvider {
  var favs;
  QuoteDataProvider() {
    FavoriteDataProvider.dbInstance
        .readFromDatabase()
        .then((value) => favs = value);
  }
  Future<List<Quote>> readJSON(String url) async {
    final String response =
        await rootBundle.loadString("assets/jsons/quotes.json");
    final data = await json.decode(response) as List;

    var quotesmapped = data.map((quote) => Quote.fromJson(quote)).toList();

    return quotesmapped;
  }

  // List<Quote> fetchQuotes(url) {
  //   List<Quote> fetchedQuotes;
  //   readJSON(url).then((quotes) {
  //     fetchedQuotes = quotes;
  //   });
  //   return fetchedQuotes;
  // }
  //
  // Quote fetchQuotes(url) {
  //   List<Quote> fetchedQuotes;
  //   readJSON(url).then((quotes) {
  //     fetchedQuotes = quotes;
  //     return fetchedQuotes[0];
  //   });
  //   int index = 0 + rand.nextInt((fetchedQuotes.length));
  //   return fetchedQuotes[index];
  // }
}
