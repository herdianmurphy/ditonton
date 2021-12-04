import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';

part 'event/search_event_tv.dart';
part 'state/search_state_tv.dart';

class SearchBlocTv extends Bloc<SearchEventTv, SearchStateTv> {
  final SearchTvSeries _searchTvSeries;

  @override
  Stream<Transition<SearchEventTv, SearchStateTv>> transformEvents(
      Stream<SearchEventTv> events,
      TransitionFunction<SearchEventTv, SearchStateTv> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  SearchBlocTv(this._searchTvSeries) : super(SearchEmptyTv());

  @override
  Stream<SearchStateTv> mapEventToState(
      SearchEventTv event,
      ) async* {
    if (event is OnQueryChangedTv) {
      final query = event.query;
      print(query);

      yield SearchLoadingTv();
      final result = await _searchTvSeries.execute(query);

      yield* result.fold(
            (failure) async* {
          yield SearchErrorTv(failure.message);
        },
            (data) async* {
          yield SearchHasDataTv(data);
        },
      );
    }
  }
}