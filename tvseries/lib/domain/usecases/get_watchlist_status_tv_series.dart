import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetWatchListStatusTvSeries {
  final TvSeriesRepository repository;

  GetWatchListStatusTvSeries(this.repository);

  Future<Either<Failure, bool>> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
