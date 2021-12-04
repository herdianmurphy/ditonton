import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetWatchListStatus {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<Either<Failure, bool>> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
