part of 'quote_bloc.dart';

@immutable
abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

class QuoteLoading extends QuoteState {}

// class QuoteLoadSuccessful extends QuoteState {
//   final List<Quote> quotes;

//   QuoteLoadSuccessful([this.quotes]);

//   @override
//   List<Object> get props => [quotes];
// }

class QuoteLoadSuccessful extends QuoteState {
  final List<Quote> quotes;
  final Language lang;
  int currentIndex;

  QuoteLoadSuccessful({this.quotes, this.currentIndex, this.lang});

  @override
  List<Object> get props => [quotes];
}

class QuoteOperationFailure extends QuoteState {}
