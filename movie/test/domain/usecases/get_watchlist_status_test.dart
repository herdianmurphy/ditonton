import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatus usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchListStatus(mockMovieRepository);
  });

  group('Get Watchlist Status', () {
    test('should get watchlist status true from repository',
            () async {
          // arrange
          when(mockMovieRepository.isAddedToWatchlist(1))
              .thenAnswer((_) async => Right(true));
          // act
          final result = await usecase.execute(1);
          // assert
          expect(result, Right(true));
        });

    test('should get watchlist status false from repository',
            () async {
          // arrange
          when(mockMovieRepository.isAddedToWatchlist(1))
              .thenAnswer((_) async => Right(false));
          // act
          final result = await usecase.execute(1);
          // assert
          expect(result, Right(false));
        });
  });
}
