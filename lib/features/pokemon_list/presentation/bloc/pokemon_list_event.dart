import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object> get props => [];
}

class LoadPokemonList extends PokemonListEvent {}

class RefreshPokemonList extends PokemonListEvent {}
