part of 'quote_bloc.dart';

@immutable
abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class FetchQuoteEvent extends QuoteEvent {
  final String url;
  final bool indexChanged;
  final Language lang;
  const FetchQuoteEvent({this.url, this.indexChanged, this.lang});

  @override
  List<Object> get props => [url, indexChanged, lang];
}
