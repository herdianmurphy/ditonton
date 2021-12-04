import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailResponse extends Equatable {
  TvSeriesDetailResponse({
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
  final List<GenreModel> genres;
  final List<int> runTime;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final double voteAverage;
  final String overview;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        id: json["id"],
        posterPath: json["poster_path"],
        name: json["name"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        runTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poster_path": posterPath,
        "name": name,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "episode_run_time": List<dynamic>.from(runTime.map((x) => x)),
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "vote_average": voteAverage,
        "overview": overview,
      };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      id: this.id,
      posterPath: this.posterPath,
      name: this.name,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      runTime: this.runTime,
      numberOfEpisodes: this.numberOfEpisodes,
      numberOfSeasons: this.numberOfSeasons,
      voteAverage: this.voteAverage,
      overview: this.overview,
    );
  }

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
