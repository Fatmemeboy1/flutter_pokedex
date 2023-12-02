import 'dart:ui';

import 'package:final_project_class_g/models/pokemon.dart';
import 'package:final_project_class_g/screens/pkm_detail_page.dart';
import 'package:flutter/material.dart';

import 'screens/homepage.dart';

void main() {
  runApp(
    MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {
        '/': (context) => const HomePage(),
        'pokemon_detail': (context) {
          final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
          return PokemonDetailPage(pokemon: pokemon);
        },
      },
    ),
  );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
