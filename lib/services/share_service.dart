import 'package:motivate_linux/model/quotes.dart';
import 'package:share/share.dart';

class ShareService {
  void shareQuote(Quote quote) {
    Share.share(
        "${quote.engversion}\n\n${quote.engperson}\n\n\n${quote.amhversion}\n\n${quote.amhperson}");
  }
}
