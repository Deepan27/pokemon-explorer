import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/network/connectivity_cubit.dart';
import '../bloc/pokemon_list_bloc.dart';
import '../bloc/pokemon_list_event.dart';
import '../bloc/pokemon_list_state.dart';
import '../../../pokemon_detail/presentation/pages/pokemon_detail_screen.dart';
import '../../domain/entities/pokemon.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PokemonListBloc>()..add(LoadPokemonList()),
      child: const PokemonListView(),
    );
  }
}

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonListBloc>().add(LoadPokemonList());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<PokemonListBloc>().add(RefreshPokemonList());
              },
              child: BlocListener<ConnectivityCubit, bool>(
                listener: (context, isOnline) {
                  if (isOnline) {
                    context.read<PokemonListBloc>().add(RefreshPokemonList());
                  }
                },
                child: BlocBuilder<PokemonListBloc, PokemonListState>(
                  builder: (context, state) {
                    if (state is PokemonListInitial ||
                        (state is PokemonListLoading &&
                            state is! PokemonListLoaded)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PokemonListError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is PokemonListLoaded) {
                      if (state.pokemonList.isEmpty) {
                        return const Center(child: Text('No Pokemon found'));
                      }
                      return GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: state.hasReachedMax
                            ? state.pokemonList.length
                            : state.pokemonList.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.pokemonList.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final pokemon = state.pokemonList[index];
                          return PokemonCard(pokemon: pokemon);
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(pokemonId: pokemon.id),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<File>(
                future: sl<ImageService>().getOptimizedImage(
                  pokemon.imageUrl,
                  width: 256,
                  height: 256,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.file(snapshot.data!);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                pokemon.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
