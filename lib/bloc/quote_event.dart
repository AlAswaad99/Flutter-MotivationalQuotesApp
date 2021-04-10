part of 'quote_bloc.dart';

@immutable
abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class FetchQuoteEvent extends QuoteEvent {
  final String url;
  final int currntIndex;
  final Language lang;
  const FetchQuoteEvent({this.url, this.currntIndex, this.lang});

  @override
  List<Object> get props => [url, currntIndex, lang];
}
