import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import 'on_the_air_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries])
void main() {
  late OnTheAirBloc onTheAirBloc;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    onTheAirBloc = OnTheAirBloc(mockGetOnTheAirTvSeries);
  });

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

  test('initial state should be empty', () {
    expect(onTheAirBloc.state, OnTheAirEmpty());
  });

  blocTest<OnTheAirBloc, OnTheAirState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return onTheAirBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAir()),
    expect: () => [
      OnTheAirLoading(),
      OnTheAirHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTvSeries.execute());
    },
  );

  blocTest<OnTheAirBloc, OnTheAirState>(
    'Should emit [Loading, Error] when get on the air tv series is unsuccessful',
    build: () {
      when(mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAir()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirLoading(),
      OnTheAirError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTvSeries.execute());
    },
  );
}
