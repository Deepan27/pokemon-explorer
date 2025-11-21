import 'dart:convert';
import '../../domain/entities/pokemon.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';

class PokemonModel extends Pokemon {
  final DateTime? lastUpdated;

  const PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    super.height,
    super.weight,
    super.types,
    super.abilities,
    super.stats,
    this.lastUpdated,
  });

  factory PokemonModel.fromJsonList(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(url.split('/').reversed.skip(1).first);
    return PokemonModel(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      lastUpdated: DateTime.now(),
    );
  }

  factory PokemonModel.fromJsonDetail(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((a) => a['ability']['name'] as String)
          .toList(),
      stats: Map.fromEntries((json['stats'] as List).map(
          (s) => MapEntry(s['stat']['name'] as String, s['base_stat'] as int))),
      lastUpdated: DateTime.now(),
    );
  }

  // Convert from Drift Table Data
  factory PokemonModel.fromTable(PokemonItem item) {
    return PokemonModel(
      id: item.id,
      name: item.name,
      imageUrl: item.imageUrl ?? '',
      height: item.height,
      weight: item.weight,
      types: item.types != null
          ? List<String>.from(jsonDecode(item.types!))
          : null,
      abilities: item.abilities != null
          ? List<String>.from(jsonDecode(item.abilities!))
          : null,
      stats: item.stats != null
          ? Map<String, int>.from(jsonDecode(item.stats!))
          : null,
      lastUpdated: item.lastUpdated,
    );
  }

  // Convert to Drift Table Companion (for insert/update)
  PokemonItemsCompanion toCompanion() {
    return PokemonItemsCompanion.insert(
      id: drift.Value(id),
      name: name,
      imageUrl: drift.Value(imageUrl),
      height: drift.Value(height),
      weight: drift.Value(weight),
      types: drift.Value(types != null ? jsonEncode(types) : null),
      abilities: drift.Value(abilities != null ? jsonEncode(abilities) : null),
      stats: drift.Value(stats != null ? jsonEncode(stats) : null),
      lastUpdated: drift.Value(DateTime.now()),
    );
  }
}
