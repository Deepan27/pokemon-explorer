import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../pokemon_list/domain/repositories/pokemon_repository.dart';
import 'pokemon_detail_event.dart';
import 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository repository;

  PokemonDetailBloc({required this.repository}) : super(PokemonDetailInitial()) {
    on<LoadPokemonDetail>(_onLoadPokemonDetail);
  }

  Future<void> _onLoadPokemonDetail(
    LoadPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading());
    final result = await repository.getPokemonDetail(event.id);
    result.fold(
      (failure) => emit(PokemonDetailError(failure.message)),
      (pokemon) => emit(PokemonDetailLoaded(pokemon)),
    );
  }
}
