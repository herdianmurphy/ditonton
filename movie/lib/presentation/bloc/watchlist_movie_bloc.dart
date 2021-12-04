import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/movie.dart';

part 'event/watchlist_movie_event.dart';
part 'state/watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMovieBloc(this._getWatchListStatus, this._saveWatchlist,
      this._removeWatchlist, this._getWatchlistMovies)
      : super(WatchlistMovieEmpty());

  @override
  Stream<WatchlistMovieState> mapEventToState(
      WatchlistMovieEvent event) async* {
    if (event is LoadWatchlistMovieStatus) {
      final id = event.id;
      final result = await _getWatchListStatus.execute(id);
      yield* result.fold(
        (failure) async* {
          yield WatchlistMovieError(failure.message);
        },
        (result) async* {
          yield WatchlistMovieLoaded(result);
        },
      );
    } else if (event is SaveMovieToWatchlist) {
      final movie = event.movie;
      final result = await _saveWatchlist.execute(movie);
      yield* result.fold(
        (failure) async* {
          yield WatchlistMovieError(failure.message);
        },
        (result) async* {
          yield WatchlistMovieLoaded(true);
        },
      );
    } else if (event is RemoveMovieFromWatchlist) {
      final movie = event.movie;
      final result = await _removeWatchlist.execute(movie);
      yield* result.fold(
        (failure) async* {
          yield WatchlistMovieError(failure.message);
        },
        (result) async* {
          yield WatchlistMovieLoaded(false);
        },
      );
    } else if (event is FetchWatchlistMovie) {
      yield WatchlistMovieLoading();
      final result = await _getWatchlistMovies.execute();

      yield* result.fold(
            (failure) async* {
          yield WatchlistMovieError(failure.message);
        },
            (data) async* {
          yield WatchlistMovieHasData(data);
        },
      );
    }
  }
}
