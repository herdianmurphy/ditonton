import 'package:core/core.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvSeries = TvSeries(
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

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  id: 90462,
  posterPath: 'posterPath',
  name: 'name',
  genres: [Genre(id: 35, name: 'Comedy')],
  runTime: [46],
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  voteAverage: 1.0,
  overview: 'overview',
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 90462,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 90462,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 90462,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
