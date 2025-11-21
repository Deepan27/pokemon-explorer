import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getPokemonList({int offset = 0, int limit = 20});
  Future<PokemonModel?> getPokemonDetail(int id);
  Future<void> cachePokemonList(List<PokemonModel> pokemonList);
  Future<void> cachePokemonDetail(PokemonModel pokemon);
}

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final AppDatabase database;

  PokemonLocalDataSourceImpl({required this.database});

  @override
  Future<List<PokemonModel>> getPokemonList({int offset = 0, int limit = 20}) async {
    try {
      final query = database.select(database.pokemonItems)
        ..limit(limit, offset: offset);
      final items = await query.get();
      return items.map((item) => PokemonModel.fromTable(item)).toList();
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<PokemonModel?> getPokemonDetail(int id) async {
    try {
      final query = database.select(database.pokemonItems)
        ..where((tbl) => tbl.id.equals(id));
      final item = await query.getSingleOrNull();
      return item != null ? PokemonModel.fromTable(item) : null;
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> cachePokemonList(List<PokemonModel> pokemonList) async {
    try {
      await database.batch((batch) {
        batch.insertAll(
          database.pokemonItems,
          pokemonList.map((e) => e.toCompanion()).toList(),
          mode: InsertMode.insertOrReplace,
        );
      });
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> cachePokemonDetail(PokemonModel pokemon) async {
    try {
      await database.into(database.pokemonItems).insertOnConflictUpdate(pokemon.toCompanion());
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
