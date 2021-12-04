import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/tvseries.dart';

part 'event/tv_series_detail_event.dart';
part 'state/tv_series_detail_state.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail _getTvSeriesDetail;

  TvSeriesDetailBloc(this._getTvSeriesDetail)
      : super(TvSeriesDetailEmpty());

  @override
  Stream<TvSeriesDetailState> mapEventToState(
    TvSeriesDetailEvent event,
  ) async* {
    if (event is FetchTvSeriesDetail) {
      final id = event.id;

      yield TvSeriesDetailLoading();
      final result = await _getTvSeriesDetail.execute(id);

      yield* result.fold(
        (failure) async* {
          yield TvSeriesDetailError(failure.message);
        },
        (data) async* {
          yield TvSeriesDetailHasData(data);
        },
      );
    }
  }
}
