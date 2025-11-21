import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_explorer/core/errors/failures.dart';
import 'package:pokemon_explorer/features/pokemon_list/data/datasources/pokemon_local_data_source.dart';
import 'package:pokemon_explorer/features/pokemon_list/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokemon_explorer/features/pokemon_list/data/models/pokemon_model.dart';
import 'package:pokemon_explorer/features/pokemon_list/data/repositories/pokemon_repository_impl.dart';

class MockRemoteDataSource extends Mock implements PokemonRemoteDataSource {}

class MockLocalDataSource extends Mock implements PokemonLocalDataSource {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late PokemonRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockConnectionChecker = MockInternetConnectionChecker();
    repository = PokemonRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectionChecker: mockConnectionChecker,
    );
  });

  final tPokemonModel = PokemonModel(
    id: 1,
    name: 'test',
    imageUrl: 'url',
    lastUpdated: DateTime.now(),
  );
  final tPokemonList = [tPokemonModel];

  group('getPokemonList', () {
    test('should return local data when available', () async {
      // arrange
      when(() => mockLocalDataSource.getPokemonList(offset: 0, limit: 1))
          .thenAnswer((_) async => tPokemonList);
      // act
      final result = await repository.getPokemonList(offset: 0, limit: 1);
      // assert
      verify(() => mockLocalDataSource.getPokemonList(offset: 0, limit: 1));
      expect(result, Right(tPokemonList));
    });

    test('should return remote data when local is empty and online', () async {
      // arrange
      when(() => mockLocalDataSource.getPokemonList(offset: 0, limit: 20))
          .thenAnswer((_) async => []);
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPokemonList(offset: 0, limit: 20))
          .thenAnswer((_) async => tPokemonList);
      when(() => mockLocalDataSource.cachePokemonList(tPokemonList))
          .thenAnswer((_) async => {});
      // act
      final result = await repository.getPokemonList(offset: 0, limit: 20);
      // assert
      verify(() => mockRemoteDataSource.getPokemonList(offset: 0, limit: 20));
      verify(() => mockLocalDataSource.cachePokemonList(tPokemonList));
      expect(result, Right(tPokemonList));
    });

    test('should return ConnectionFailure when local is empty and offline',
        () async {
      // arrange
      when(() => mockLocalDataSource.getPokemonList(offset: 0, limit: 20))
          .thenAnswer((_) async => []);
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      // act
      final result = await repository.getPokemonList(offset: 0, limit: 20);
      // assert
      expect(
          result,
          const Left(
              ConnectionFailure('No internet connection and no cached data')));
    });
  });
}
