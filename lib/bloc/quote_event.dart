part of 'quote_bloc.dart';

@immutable
abstract class QuoteEvent {
  const QuoteEvent();
}

class FetchQuoteEvent extends QuoteEvent {
  final String url;
  const FetchQuoteEvent({this.url});
  @override
  // TODO: implement props[
  List<Object> get props => [];
}
