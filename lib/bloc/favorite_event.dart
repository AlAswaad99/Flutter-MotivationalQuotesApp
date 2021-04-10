part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FavoritesFetch extends FavoriteEvent {
  const FavoritesFetch();

  @override
  List<Object> get props => [];
}

class FavoriteAdd extends FavoriteEvent {
  final Quote quote;
  const FavoriteAdd(this.quote);

  @override
  List<Object> get props => [quote];
}

class FavoriteDelete extends FavoriteEvent {
  final Quote quote;
  const FavoriteDelete(this.quote);

  @override
  List<Object> get props => [quote];
}

class FavoritesSearch extends FavoriteEvent {
  final String keyword;
  const FavoritesSearch(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class CheckLike extends FavoriteEvent {
  final Quote quote;
  const CheckLike({this.quote});

  @override
  List<Object> get props => [quote];
}
