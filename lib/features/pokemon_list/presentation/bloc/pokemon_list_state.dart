import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';

abstract class PokemonListState extends Equatable {
  const PokemonListState();
  
  @override
  List<Object> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  final List<Pokemon> pokemonList;
  final bool hasReachedMax;

  const PokemonListLoaded({
    required this.pokemonList,
    this.hasReachedMax = false,
  });

  PokemonListLoaded copyWith({
    List<Pokemon>? pokemonList,
    bool? hasReachedMax,
  }) {
    return PokemonListLoaded(
      pokemonList: pokemonList ?? this.pokemonList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [pokemonList, hasReachedMax];
}

class PokemonListError extends PokemonListState {
  final String message;

  const PokemonListError(this.message);

  @override
  List<Object> get props => [message];
}
