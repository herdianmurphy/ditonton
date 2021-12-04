import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/tvseries.dart';

part 'event/top_rated_tv_series_event.dart';
part 'state/top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this._getTopRatedTvSeries) : super(TopRatedTvSeriesEmpty());

  @override
  Stream<TopRatedTvSeriesState> mapEventToState(
    TopRatedTvSeriesEvent event,
  ) async* {
    if (event is FetchTopRatedTvSeries) {
      yield TopRatedTvSeriesLoading();
      final result = await _getTopRatedTvSeries.execute();

      yield* result.fold(
        (failure) async* {
          yield TopRatedTvSeriesError(failure.message);
        },
        (data) async* {
          yield TopRatedTvSeriesHasData(data);
        },
      );
    }
  }
}
