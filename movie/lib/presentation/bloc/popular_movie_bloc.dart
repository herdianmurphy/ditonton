import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/movie.dart';

part 'event/popular_movie_event.dart';
part 'state/popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(PopularMovieEmpty());

  @override
  Stream<PopularMovieState> mapEventToState(
    PopularMovieEvent event,
  ) async* {
    if (event is FetchPopularMovie) {
      yield PopularMovieLoading();
      final result = await _getPopularMovies.execute();

      yield* result.fold(
        (failure) async* {
          yield PopularMovieError(failure.message);
        },
        (data) async* {
          yield PopularMovieHasData(data);
        },
      );
    }
  }
}
