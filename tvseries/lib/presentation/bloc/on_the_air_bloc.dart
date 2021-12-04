import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/tvseries.dart';

part 'event/on_the_air_event.dart';
part 'state/on_the_air_state.dart';

class OnTheAirBloc extends Bloc<OnTheAirEvent, OnTheAirState> {
  final GetOnTheAirTvSeries _getOnTheAirTvSeries;

  OnTheAirBloc(this._getOnTheAirTvSeries) : super(OnTheAirEmpty());

  @override
  Stream<OnTheAirState> mapEventToState(
    OnTheAirEvent event,
  ) async* {
    if (event is FetchOnTheAir) {
      yield OnTheAirLoading();
      final result = await _getOnTheAirTvSeries.execute();

      yield* result.fold(
        (failure) async* {
          yield OnTheAirError(failure.message);
        },
        (data) async* {
          yield OnTheAirHasData(data);
        },
      );
    }
  }
}
