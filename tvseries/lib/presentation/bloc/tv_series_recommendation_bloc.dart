import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/tvseries.dart';

part 'event/tv_series_recommendation_event.dart';
part 'state/tv_series_recommendation_state.dart';

class TvSeriesRecommendationBloc extends Bloc<TvSeriesRecommendationEvent, TvSeriesRecommendationState> {
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;

  TvSeriesRecommendationBloc(this._getTvSeriesRecommendations) : super(TvSeriesRecommendationEmpty());

  @override
  Stream<TvSeriesRecommendationState> mapEventToState(
    TvSeriesRecommendationEvent event,
  ) async* {
    if (event is FetchTvSeriesRecommendation) {
      final id = event.id;

      yield TvSeriesRecommendationLoading();
      final result = await _getTvSeriesRecommendations.execute(id);

      yield* result.fold(
        (failure) async* {
          yield TvSeriesRecommendationError(failure.message);
        },
        (data) async* {
          yield TvSeriesRecommendationHasData(data);
        },
      );
    }
  }
}
