part of '../watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistTvSeriesStatus extends WatchlistTvSeriesEvent {
  final int id;

  LoadWatchlistTvSeriesStatus(this.id);

  @override
  List<Object> get props => [id];
}

class SaveTvSeriesToWatchlist extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  SaveTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlist extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  RemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {

  @override
  List<Object> get props => [];
}