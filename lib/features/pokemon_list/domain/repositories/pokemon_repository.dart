import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({int offset = 0, int limit = 20});
  Future<Either<Failure, Pokemon>> getPokemonDetail(int id);
}
