import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  // Detail fields (nullable for list view)
  final int? height;
  final int? weight;
  final List<String>? types;
  final List<String>? abilities;
  final Map<String, int>? stats;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.height,
    this.weight,
    this.types,
    this.abilities,
    this.stats,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, height, weight, types, abilities, stats];
}
