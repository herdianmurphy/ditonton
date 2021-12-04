import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:tvseries/tvseries.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}
class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MockMovieWatchlistBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class WatchlistMovieEventFake extends Fake implements WatchlistMovieEvent {}
class WatchlistMovieStateFake extends Fake implements WatchlistMovieState {}

class MockMovieRecommendationBloc
    extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

class MovieRecommendationEventFake extends Fake
    implements MovieRecommendationEvent {}
class MovieRecommendationStateFake extends Fake
    implements MovieRecommendationState {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class PopularMovieEventFake extends PopularMovieEvent {}
class PopularMovieStateFake extends PopularMovieState {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class TopRatedMovieEventFake extends TopRatedMovieEvent {}
class TopRatedMovieStateFake extends TopRatedMovieState {}

class MockTvSeriesDetailBloc extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class TvSeriesDetailEventFake extends Fake implements TvSeriesDetailEvent {}
class TvSeriesDetailStateFake extends Fake implements TvSeriesDetailState {}

class MockTvSeriesWatchlistBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class WatchlistTvSeriesEventFake extends Fake implements WatchlistTvSeriesEvent {}
class WatchlistTvSeriesStateFake extends Fake implements WatchlistTvSeriesState {}

class MockTvSeriesRecommendationBloc
    extends MockBloc<TvSeriesRecommendationEvent, TvSeriesRecommendationState>
    implements TvSeriesRecommendationBloc {}

class TvSeriesRecommendationEventFake extends Fake
    implements TvSeriesRecommendationEvent {}
class TvSeriesRecommendationStateFake extends Fake
    implements TvSeriesRecommendationState {}

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

class PopularTvSeriesEventFake extends PopularTvSeriesEvent {}
class PopularTvSeriesStateFake extends PopularTvSeriesState {}

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

class TopRatedTvSeriesEventFake extends TopRatedTvSeriesEvent {}
class TopRatedTvSeriesStateFake extends TopRatedTvSeriesState {}

@GenerateMocks([
  MovieRepository,
  TvSeriesRepository,
  RemoteDataSource,
  LocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}
