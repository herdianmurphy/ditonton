part of '../watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistMovieStatus extends WatchlistMovieEvent {
  final int id;

  LoadWatchlistMovieStatus(this.id);

  @override
  List<Object> get props => [id];
}

class SaveMovieToWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  SaveMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class FetchWatchlistMovie extends WatchlistMovieEvent {

  @override
  List<Object> get props => [];
}