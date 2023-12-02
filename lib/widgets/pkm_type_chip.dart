import 'package:final_project_class_g/utilties/custom_extnsions.dart';
import 'package:final_project_class_g/utilties/pkm_type_colors.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonTypeChip extends StatelessWidget {
  const PokemonTypeChip({
    super.key,
    required this.type,
  });

  final Type type;

  @override
  Widget build(BuildContext context) {
    final typeColor = pkmTypeColors[type.name]!;

    return Chip(
        backgroundColor: Color(typeColor),
        shape: const StadiumBorder(),
        label: Text(
          type.name.capitalize(),
          style: const TextStyle(color: Colors.white),
        ));
  }
}
