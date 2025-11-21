import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../domain/repositories/pokemon_repository.dart';
import 'pokemon_list_event.dart';
import 'pokemon_list_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository repository;

  PokemonListBloc({required this.repository}) : super(PokemonListInitial()) {
    on<LoadPokemonList>(
      _onLoadPokemonList,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RefreshPokemonList>(_onRefreshPokemonList);
  }

  Future<void> _onLoadPokemonList(
    LoadPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state is PokemonListLoaded && (state as PokemonListLoaded).hasReachedMax) return;

    try {
      if (state is PokemonListInitial) {
        emit(PokemonListLoading());
        final result = await repository.getPokemonList(offset: 0);
        result.fold(
          (failure) => emit(PokemonListError(failure.message)),
          (pokemonList) => emit(PokemonListLoaded(
            pokemonList: pokemonList,
            hasReachedMax: pokemonList.length < 20,
          )),
        );
        return;
      }

      if (state is PokemonListLoaded) {
        final currentState = state as PokemonListLoaded;
        final result = await repository.getPokemonList(
          offset: currentState.pokemonList.length,
        );
        
        result.fold(
          (failure) => emit(PokemonListError(failure.message)),
          (pokemonList) {
            if (pokemonList.isEmpty) {
              emit(currentState.copyWith(hasReachedMax: true));
            } else {
              emit(currentState.copyWith(
                pokemonList: List.of(currentState.pokemonList)..addAll(pokemonList),
                hasReachedMax: false,
              ));
            }
          },
        );
      }
    } catch (e) {
      emit(PokemonListError(e.toString()));
    }
  }

  Future<void> _onRefreshPokemonList(
    RefreshPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(PokemonListLoading());
    try {
      // For refresh, we start from offset 0
      final result = await repository.getPokemonList(offset: 0);
      result.fold(
        (failure) => emit(PokemonListError(failure.message)),
        (pokemonList) => emit(PokemonListLoaded(
          pokemonList: pokemonList,
          hasReachedMax: pokemonList.length < 20,
        )),
      );
    } catch (e) {
      emit(PokemonListError(e.toString()));
    }
  }
}
