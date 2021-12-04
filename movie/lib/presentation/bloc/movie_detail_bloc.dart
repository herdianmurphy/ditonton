import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/movie.dart';

part 'event/movie_detail_event.dart';
part 'state/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail)
      : super(MovieDetailEmpty());

  @override
  Stream<MovieDetailState> mapEventToState(
    MovieDetailEvent event,
  ) async* {
    if (event is FetchMovieDetail) {
      final id = event.id;

      yield MovieDetailLoading();
      final result = await _getMovieDetail.execute(id);

      yield* result.fold(
        (failure) async* {
          yield MovieDetailError(failure.message);
        },
        (data) async* {
          yield MovieDetailHasData(data);
        },
      );
    }
  }
}
