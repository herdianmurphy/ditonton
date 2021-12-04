import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/tvseries.dart';

part 'event/popular_tv_series_event.dart';
part 'state/popular_tv_series_state.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries _getPopularTvSeries;

  PopularTvSeriesBloc(this._getPopularTvSeries) : super(PopularTvSeriesEmpty());

  @override
  Stream<PopularTvSeriesState> mapEventToState(
    PopularTvSeriesEvent event,
  ) async* {
    if (event is FetchPopularTvSeries) {
      yield PopularTvSeriesLoading();
      final result = await _getPopularTvSeries.execute();

      yield* result.fold(
        (failure) async* {
          yield PopularTvSeriesError(failure.message);
        },
        (data) async* {
          yield PopularTvSeriesHasData(data);
        },
      );
    }
  }
}
