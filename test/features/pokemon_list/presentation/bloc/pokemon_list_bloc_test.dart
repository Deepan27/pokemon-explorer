import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_explorer/core/errors/failures.dart';
import 'package:pokemon_explorer/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokemon_explorer/features/pokemon_list/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon_list/presentation/bloc/pokemon_list_bloc.dart';
import 'package:pokemon_explorer/features/pokemon_list/presentation/bloc/pokemon_list_event.dart';
import 'package:pokemon_explorer/features/pokemon_list/presentation/bloc/pokemon_list_state.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late PokemonListBloc bloc;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    bloc = PokemonListBloc(repository: mockRepository);
  });

  const tPokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl: 'url',
  );
  final tPokemonList = [tPokemon];

  test('initial state should be PokemonListInitial', () {
    expect(bloc.state, equals(PokemonListInitial()));
  });

  blocTest<PokemonListBloc, PokemonListState>(
    'emits [PokemonListLoading, PokemonListLoaded] when data is gotten successfully',
    build: () {
      when(() => mockRepository.getPokemonList(offset: 0))
          .thenAnswer((_) async => Right(tPokemonList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPokemonList()),
    expect: () => [
      PokemonListLoading(),
      PokemonListLoaded(pokemonList: tPokemonList, hasReachedMax: true),
    ],
  );

  blocTest<PokemonListBloc, PokemonListState>(
    'emits [PokemonListLoading, PokemonListError] when getting data fails',
    build: () {
      when(() => mockRepository.getPokemonList(offset: 0))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPokemonList()),
    expect: () => [
      PokemonListLoading(),
      const PokemonListError('Server Failure'),
    ],
  );

  blocTest<PokemonListBloc, PokemonListState>(
    'emits [PokemonListLoading, PokemonListLoaded] when RefreshPokemonList is added',
    build: () {
      when(() => mockRepository.getPokemonList(offset: 0))
          .thenAnswer((_) async => Right(tPokemonList));
      return bloc;
    },
    act: (bloc) => bloc.add(RefreshPokemonList()),
    expect: () => [
      PokemonListLoading(),
      PokemonListLoaded(pokemonList: tPokemonList, hasReachedMax: true),
    ],
  );
}
