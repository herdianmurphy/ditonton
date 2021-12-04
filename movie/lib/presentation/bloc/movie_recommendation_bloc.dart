import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/movie.dart';

part 'event/movie_recommendation_event.dart';
part 'state/movie_recommendation_state.dart';

class MovieRecommendationBloc extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations) : super(MovieRecommendationEmpty());

  @override
  Stream<MovieRecommendationState> mapEventToState(
    MovieRecommendationEvent event,
  ) async* {
    if (event is FetchMovieRecommendation) {
      final id = event.id;

      yield MovieRecommendationLoading();
      final result = await _getMovieRecommendations.execute(id);

      yield* result.fold(
        (failure) async* {
          yield MovieRecommendationError(failure.message);
        },
        (data) async* {
          yield MovieRecommendationHasData(data);
        },
      );
    }
  }
}
