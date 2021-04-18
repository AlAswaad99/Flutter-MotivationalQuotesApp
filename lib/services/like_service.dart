import 'package:motivate_linux/model/quotes.dart';

class LikeServce {
  bool checkIfLiked(Quote quote, List<Quote> favs) {
    for (var item in favs) {
      if (quote.id == item.id) {
        return true;
      }
    }
    return false;
  }
}
