import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/model/quotes.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteDataProvider quoteDataProvider;
  QuoteBloc({@required this.quoteDataProvider})
      : assert(quoteDataProvider != null),
        super(QuoteLoading());

  @override
  Stream<QuoteState> mapEventToState(
    QuoteEvent event,
  ) async* {
    if (event is FetchQuoteEvent) {
      yield QuoteLoading();
      try {
        final quotes = await quoteDataProvider.readJSON();
        if (event.lang != null) {
          yield QuoteLoadSuccessful(
              quotes: quotes,
              indexChanged: event.indexChanged,
              lang: event.lang);
        } else {
          yield QuoteLoadSuccessful(quotes: quotes);
        }
      } catch (e) {
        yield QuoteOperationFailure();
      }
    }
  }
}
