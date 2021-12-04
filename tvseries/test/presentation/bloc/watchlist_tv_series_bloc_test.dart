import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tvseries/tvseries.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
  GetWatchlistTvSeries
])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatusTvSeries();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();

    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(mockGetWatchListStatus,
        mockSaveWatchlist, mockRemoveWatchlist, mockGetWatchlistTvSeries);
  });

  const tId = 1;
  final tTvSeries = TvSeries(
    backdropPath: '/xAKMj134XHQVNHLC6rWsccLMenG.jpg',
    firstAirDate: '2021-10-12',
    genreIds: [10765, 35, 80],
    id: 90462,
    name: 'Chucky',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Chucky',
    overview:
    'After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.',
    popularity: 5211.783,
    posterPath: '/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg',
    voteAverage: 8,
    voteCount: 1797,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Watchlist', () {
    test('initial state should be empty', () {
      expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
    });

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTvSeriesStatus(tId)),
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Success'));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(SaveTvSeriesToWatchlist(testTvSeriesDetail)),
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTvSeriesDetail));
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Removed'));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testTvSeriesDetail));
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should change tv series data when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );
  });
}
