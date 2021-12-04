import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:test/test.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchListStatus, SaveWatchlist, RemoveWatchlist, GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchlistMovies = MockGetWatchlistMovies();

    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchListStatus,
        mockSaveWatchlist, mockRemoveWatchlist, mockGetWatchlistMovies);
  });

  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('Watchlist', () {
    test('initial state should be empty', () {
      expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
    });

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistMovieStatus(tId)),
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(SaveMovieToWatchlist(testMovieDetail)),
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should change movies data when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovie()),
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovie()),
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}
