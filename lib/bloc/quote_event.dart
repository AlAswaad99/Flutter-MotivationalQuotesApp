part of 'quote_bloc.dart';

@immutable
abstract class QuoteEvent {
  const QuoteEvent();
}

class FetchQuoteEvent extends QuoteEvent {
  final String url;
  final int currntIndex;
  final Language lang;
  const FetchQuoteEvent({this.url, this.currntIndex, this.lang});
}
