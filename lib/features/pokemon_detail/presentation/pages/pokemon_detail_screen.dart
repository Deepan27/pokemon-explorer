import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/image_service.dart';
import '../bloc/pokemon_detail_bloc.dart';
import '../bloc/pokemon_detail_event.dart';
import '../bloc/pokemon_detail_state.dart';

class PokemonDetailScreen extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailScreen({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PokemonDetailBloc>()..add(LoadPokemonDetail(pokemonId)),
      child: const PokemonDetailView(),
    );
  }
}

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
        builder: (context, state) {
          if (state is PokemonDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is PokemonDetailError) {
            return Center(child: Text(state.message));
          }

          if (state is PokemonDetailLoaded) {
            final pokemon = state.pokemon;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(pokemon.name.toUpperCase()),
                    background: FutureBuilder<File>(
                      future: sl<ImageService>().getOptimizedImage(
                        pokemon.imageUrl,
                        width: 512,
                        height: 512,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.file(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Stats'),
                        if (pokemon.stats != null)
                          ...pokemon.stats!.entries.map((e) => ListTile(
                            title: Text(e.key.toUpperCase()),
                            trailing: Text(e.value.toString()),
                            dense: true,
                          )),
                        const Divider(),
                        _buildSectionTitle(context, 'Types'),
                        if (pokemon.types != null)
                          Wrap(
                            spacing: 8,
                            children: pokemon.types!.map((t) => Chip(label: Text(t))).toList(),
                          ),
                        const Divider(),
                        _buildSectionTitle(context, 'Abilities'),
                        if (pokemon.abilities != null)
                          Wrap(
                            spacing: 8,
                            children: pokemon.abilities!.map((a) => Chip(label: Text(a))).toList(),
                          ),
                        const Divider(),
                        _buildSectionTitle(context, 'Physical'),
                        ListTile(
                          title: const Text('Height'),
                          trailing: Text('${pokemon.height} dm'),
                        ),
                        ListTile(
                          title: const Text('Weight'),
                          trailing: Text('${pokemon.weight} hg'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
