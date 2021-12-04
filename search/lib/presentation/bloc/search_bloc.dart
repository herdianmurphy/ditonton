import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';

part 'event/search_event.dart';
part 'state/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events,
      TransitionFunction<SearchEvent, SearchState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  SearchBloc(this._searchMovies) : super(SearchEmpty());

  @override
  Stream<SearchState> mapEventToState(
      SearchEvent event,
      ) async* {
    if (event is OnQueryChanged) {
      final query = event.query;
      print(query);

      yield SearchLoading();
      final result = await _searchMovies.execute(query);

      yield* result.fold(
            (failure) async* {
          yield SearchError(failure.message);
        },
            (data) async* {
          yield SearchHasData(data);
        },
      );
    }
  }
}