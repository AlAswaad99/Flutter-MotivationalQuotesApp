part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoritesLoadSuccess extends FavoriteState {
  final List<Quote> quotes;
  // final bool isLiked;

  FavoritesLoadSuccess([this.quotes = const []]);

  @override
  List<Object> get props => [quotes];
}

class LikeDislikeQuoteState extends FavoriteState {
  // final int currntIndex;
  final bool isLiked;
  const LikeDislikeQuoteState({this.isLiked});

  @override
  List<Object> get props => [isLiked];
}

class FavoriteOperationFailure extends FavoriteState {
  FavoriteOperationFailure();
}
