import 'package:equatable/equatable.dart';
import '../../../pokemon_list/domain/entities/pokemon.dart';

abstract class PokemonDetailState extends Equatable {
  const PokemonDetailState();
  
  @override
  List<Object> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final Pokemon pokemon;

  const PokemonDetailLoaded(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonDetailError extends PokemonDetailState {
  final String message;

  const PokemonDetailError(this.message);

  @override
  List<Object> get props => [message];
}
