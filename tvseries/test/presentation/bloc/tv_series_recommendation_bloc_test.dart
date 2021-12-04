import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tvseries/tvseries.dart';

import 'tv_series_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late TvSeriesRecommendationBloc tvSeriesRecommendationBloc;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesRecommendationBloc = TvSeriesRecommendationBloc(mockGetTvSeriesRecommendations);
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

  group('Get Tv Series Recommendations', () {
    test('initial state should be empty', () {
      expect(tvSeriesRecommendationBloc.state, TvSeriesRecommendationEmpty());
    });

    blocTest<TvSeriesRecommendationBloc, TvSeriesRecommendationState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesRecommendation(tId)),
      expect: () => [
        TvSeriesRecommendationLoading(),
        TvSeriesRecommendationHasData(tTvSeriesList),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<TvSeriesRecommendationBloc, TvSeriesRecommendationState>(
      'Should emit [Loading, Error] when get tv series recommendation is unsuccessful',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeriesRecommendationBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSeriesRecommendationLoading(),
        TvSeriesRecommendationError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });
}
