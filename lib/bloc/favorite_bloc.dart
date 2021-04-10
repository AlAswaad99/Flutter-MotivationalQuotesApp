import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:motivate_linux/dataprovider/favorite_data.dart';
import 'package:motivate_linux/model/quotes.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteLoading());

  @override
  Stream<FavoriteState> mapEventToState(
    FavoriteEvent event,
  ) async* {
    if (event is FavoritesFetch) {
      yield FavoriteLoading();
      try {
        final favorites =
            await FavoriteDataProvider.dbInstance.readFromDatabase();
        yield FavoritesLoadSuccess(favorites);
      } catch (e) {
        print(e);
        yield FavoriteOperationFailure();
      }
    }
    if (event is FavoriteAdd) {
      yield FavoriteLoading();
      try {
        await FavoriteDataProvider.dbInstance.inserIntoDatabase(event.quote);
        final favorites =
            await FavoriteDataProvider.dbInstance.readFromDatabase();
        yield FavoritesLoadSuccess(favorites);
      } catch (e) {
        print(e);
        yield FavoriteOperationFailure();
      }
    }
    if (event is FavoriteDelete) {
      yield FavoriteLoading();
      try {
        await FavoriteDataProvider.dbInstance.deleteFromDatabase(event.quote);
        final favorites =
            await FavoriteDataProvider.dbInstance.readFromDatabase();
        yield FavoritesLoadSuccess(favorites);
      } catch (e) {
        print(e);
        yield FavoriteOperationFailure();
      }
    }
  }
}
