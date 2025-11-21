import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final InternetConnectionChecker connectionChecker;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });
  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList(
      {int offset = 0, int limit = 20}) async {
    try {
      // 1. Try Local
      final localData =
          await localDataSource.getPokemonList(offset: offset, limit: limit);

      bool isCacheValid = false;
      if (localData.isNotEmpty) {
        final firstItem = localData.first;
        if (firstItem.lastUpdated != null) {
          final difference = DateTime.now().difference(firstItem.lastUpdated!);
          if (difference.inHours < 24) {
            isCacheValid = true;
          }
        } else {
          // If no timestamp, assume invalid to force refresh
          isCacheValid = false;
        }
      }

      if (isCacheValid && localData.length == limit) {
        return Right(localData);
      }

      // 2. If no local data or not enough, check connection
      if (await connectionChecker.hasConnection) {
        try {
          final remoteData = await remoteDataSource.getPokemonList(
              offset: offset, limit: limit);
          await localDataSource.cachePokemonList(remoteData);
          return Right(remoteData);
        } catch (e) {
          // If remote fails, return local if we have some
          if (localData.isNotEmpty) {
            return Right(localData);
          }
          return Left(ServerFailure(e.toString()));
        }
      } else {
        // Offline and no local data (or not enough)
        if (localData.isNotEmpty) {
          return Right(localData);
        }
        return const Left(
            ConnectionFailure('No internet connection and no cached data'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pokemon>> getPokemonDetail(int id) async {
    try {
      final localPokemon = await localDataSource.getPokemonDetail(id);

      if (localPokemon != null && localPokemon.stats != null) {
        // We have full details
        return Right(localPokemon);
      }

      if (await connectionChecker.hasConnection) {
        try {
          final remotePokemon = await remoteDataSource.getPokemonDetail(id);
          await localDataSource.cachePokemonDetail(remotePokemon);
          return Right(remotePokemon);
        } catch (e) {
          if (localPokemon != null) return Right(localPokemon);
          return Left(ServerFailure(e.toString()));
        }
      } else {
        if (localPokemon != null) return Right(localPokemon);
        return const Left(
            ConnectionFailure('No internet connection and no cached data'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
