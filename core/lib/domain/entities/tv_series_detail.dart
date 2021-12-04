import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetail extends Equatable {
  TvSeriesDetail({
    required this.id,
    required this.posterPath,
    required this.name,
    required this.genres,
    required this.runTime,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.voteAverage,
    required this.overview,
  });

  final int id;
  final String posterPath;
  final String name;
  final List<Genre> genres;
  final List<int> runTime;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final double voteAverage;
  final String overview;

  @override
  List<Object?> get props => [
        id,
        posterPath,
        name,
        genres,
        runTime,
        numberOfEpisodes,
        numberOfSeasons,
        voteAverage,
        overview,
      ];
}
