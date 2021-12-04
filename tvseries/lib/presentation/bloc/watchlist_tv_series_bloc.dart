import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/tvseries.dart';

part 'event/watchlist_tv_series_event.dart';
part 'state/watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatusTvSeries _getWatchListStatus;
  final SaveWatchlistTvSeries _saveWatchlist;
  final RemoveWatchlistTvSeries _removeWatchlist;
  final GetWatchlistTvSeries _getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this._getWatchListStatus, this._saveWatchlist,
      this._removeWatchlist, this._getWatchlistTvSeries)
      : super(WatchlistTvSeriesEmpty());

  @override
  Stream<WatchlistTvSeriesState> mapEventToState(
      WatchlistTvSeriesEvent event) async* {
    if (event is LoadWatchlistTvSeriesStatus) {
      final id = event.id;
      final result = await _getWatchListStatus.execute(id);
      yield* result.fold(
        (failure) async* {
          yield WatchlistTvSeriesError(failure.message);
        },
        (result) async* {
          yield WatchlistTvSeriesLoaded(result);
        },
      );
    } else if (event is SaveTvSeriesToWatchlist) {
      final tvSeries = event.tvSeries;
      final result = await _saveWatchlist.execute(tvSeries);
      yield* result.fold(
        (failure) async* {
          yield WatchlistTvSeriesError(failure.message);
        },
        (result) async* {
          yield WatchlistTvSeriesLoaded(true);
        },
      );
    } else if (event is RemoveTvSeriesFromWatchlist) {
      final tvSeries = event.tvSeries;
      final result = await _removeWatchlist.execute(tvSeries);
      yield* result.fold(
        (failure) async* {
          yield WatchlistTvSeriesError(failure.message);
        },
        (result) async* {
          yield WatchlistTvSeriesLoaded(false);
        },
      );
    } else if (event is FetchWatchlistTvSeries) {
      yield WatchlistTvSeriesLoading();
      final result = await _getWatchlistTvSeries.execute();

      yield* result.fold(
            (failure) async* {
          yield WatchlistTvSeriesError(failure.message);
        },
            (data) async* {
          yield WatchlistTvSeriesHasData(data);
        },
      );
    }
  }
}
