import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemonList({int offset = 0, int limit = 20});
  Future<PokemonModel> getPokemonDetail(int id);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final ApiClient client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PokemonModel>> getPokemonList({int offset = 0, int limit = 20}) async {
    try {
      final response = await client.get('pokemon', queryParameters: {
        'offset': offset,
        'limit': limit,
      });
      
      final results = response.data['results'] as List;
      return results.map((json) => PokemonModel.fromJsonList(json)).toList();
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Unknown Server Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<PokemonModel> getPokemonDetail(int id) async {
    try {
      final response = await client.get('pokemon/$id');
      return PokemonModel.fromJsonDetail(response.data);
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Unknown Server Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
