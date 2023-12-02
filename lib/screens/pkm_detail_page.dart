import 'dart:convert';

import 'package:final_project_class_g/utilties/custom_extnsions.dart';
import 'package:final_project_class_g/utilties/pkm_type_colors.dart';
import 'package:final_project_class_g/widgets/pkm_type_chip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/evolution_info.dart';
import '../models/pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    final mainType = pokemon.types.first.name;
    final backgroundColor = pkmTypeColors[mainType]!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ColoredBox(
                      color: Color(backgroundColor).withOpacity(0.75),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // Back button and favorite button
                          const ActionsBar(),

                          // Pokemon name, id, and types
                          PokemonHeader(pokemon: pokemon),

                          // Pokemon images
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: size.width,
                              maxHeight: size.height * 0.35,
                            ),
                            child: Hero(
                                tag: pokemon.defaultImage,
                                child: Image.network(pokemon.defaultImage)),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    TabBar(
                      labelColor: Color(backgroundColor),
                      unselectedLabelColor: colorScheme.onBackground,
                      indicatorColor: Color(backgroundColor),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Base Stats'),
                        Tab(text: 'Evolution'),
                        Tab(text: 'Moves'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              SliverTabBuilder(
                pageKey: 'About',
                child: AboutTab(pokemon: pokemon),
              ),
              SliverTabBuilder(
                pageKey: 'Base Stats',
                child: BaseStatsTab(pokemon: pokemon),
              ),
              SliverTabBuilder(
                pageKey: 'Evolution',
                child: EvolutionTab(pokemon: pokemon),
              ),
              SliverTabBuilder(
                pageKey: 'Moves',
                child: MovesTab(pokemon: pokemon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionsBar extends StatelessWidget {
  const ActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class PokemonHeader extends StatelessWidget {
  const PokemonHeader({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return ListTile(
      title: Text(pokemon.name.capitalize()),
      titleTextStyle: txtTheme.titleLarge,
      trailing: Text(
        pokemon.id.toPaddedString(3),
        style: txtTheme.labelLarge,
      ),
      subtitle: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final type in pokemon.types) PokemonTypeChip(type: type)
        ],
      ),
    );
  }
}

class SliverTabBuilder extends StatelessWidget {
  const SliverTabBuilder({
    required this.pageKey,
    required this.child,
    super.key,
  });

  final String pageKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomScrollView(
        key: PageStorageKey(pageKey),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList(
            delegate: SliverChildListDelegate([child]),
          ),
        ],
      ),
    );
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        AboutRow(
          size: size,
          pokemon: pokemon,
          label: 'Species: ',
          value: pokemon.species.name.capitalize(),
        ),
        AboutRow(
          size: size,
          pokemon: pokemon,
          label: 'Height (m):',
          value: pokemon.height.toString(),
        ),
        AboutRow(
          size: size,
          pokemon: pokemon,
          label: 'weight (kg): ',
          value: pokemon.weight.toString(),
        ),
        AboutRow(
          size: size,
          pokemon: pokemon,
          label: 'Abilities: ',
          value: pokemon.abilities.map((e) => e.name.capitalize()).join(','),
        ),
      ],
    );
  }
}

class AboutRow extends StatelessWidget {
  const AboutRow({
    super.key,
    required this.size,
    required this.pokemon,
    required this.label,
    required this.value,
  });

  final Size size;
  final Pokemon pokemon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        SizedBox(
          width: size.width * 0.25,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

class BaseStatsTab extends StatelessWidget {
  const BaseStatsTab({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final info in pokemon.statInfo)
          StatsRow(
              label: info.stat.name.capitalize(),
              value: info.baseStat,
              max: 255)
      ],
    );
  }
}

class EvolutionTab extends StatelessWidget {
  const EvolutionTab({
    required this.pokemon,
    super.key,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final speciesURL =
        'https://pokeapi.co/api/v2/pokemon-species/${pokemon.id}/';

    final request = http.get(Uri.parse(speciesURL));

    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingWidget();

        final json = jsonDecode(snapshot.data!.body);
        final chainURL = json['evolution_chain']['url'];
        final uri = Uri.parse(chainURL);
        final request = http.get(uri);

        return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const LoadingWidget();

            final json = jsonDecode(snapshot.data!.body);
            final jsonChain = json['chain'] as Map<String, dynamic>;
            final evolutionInfo = EvolutionInfo.fromJson(jsonChain);
            final chains = parseChain(evolutionInfo);

            return Column(
              children: [
                for (final chain in chains) EvolutionRow(evolutionChain: chain),
              ],
            );
          },
        );
      },
    );
  }

  List<EvolutionChain> parseChain(EvolutionInfo evolutionInfo) {
    final chains = <EvolutionChain>[];
    final from = evolutionInfo.species.name;

    for (final info in evolutionInfo.evolvesTo) {
      final to = info.species.name;
      final chain = EvolutionChain(
        from: from,
        to: to,
        details: info.evolutionDetails,
      );

      chains.add(chain);
      chains.addAll(parseChain(info));
    }

    return chains;
  }
}

class EvolutionChain {
  EvolutionChain({
    required this.from,
    required this.to,
    required this.details,
  });

  final String from;
  final String to;
  final List<EvolutionDetail?> details;
}

class EvolutionRow extends StatelessWidget {
  const EvolutionRow({
    required this.evolutionChain,
    super.key,
  });

  final EvolutionChain evolutionChain;

  @override
  Widget build(BuildContext context) {
    final from = evolutionChain.from;
    final to = evolutionChain.to;

    final requests = [
      http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$from')),
      http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$to')),
    ];

    var trigger = '';

    for (final detail in evolutionChain.details) {
      if (detail == null) continue;

      trigger += '${detail.trigger.name.capitalize()}: ';
      if (detail.minAffection != null) {
        trigger += 'Affection: ${detail.minAffection}';
      }
      if (detail.minBeauty != null) {
        trigger += 'Beauty: ${detail.minBeauty}';
      }
      if (detail.minHappiness != null) {
        trigger += 'Happiness: ${detail.minHappiness}';
      }
      if (detail.minLevel != null) {
        trigger += 'Level: ${detail.minLevel}';
      }
      if (detail.needsOverworldRain != null && detail.needsOverworldRain!) {
        trigger += 'Needs Overworld Rain';
      }
      if (detail.item != null) {
        trigger += detail.item!.name;
      }
      if (detail.location != null) {
        trigger += detail.location!.name;
      }
      trigger += '\n';
    }

    return FutureBuilder(
      future: Future.wait(requests),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingWidget();

        final responses = snapshot.data!;
        final r1 = responses[0];
        final json1 = jsonDecode(r1.body);
        final pokemon1 = Pokemon.fromJson(json1);

        final r2 = responses[1];
        final json2 = jsonDecode(r2.body);
        final pokemon2 = Pokemon.fromJson(json2);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // From pokemon
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(pokemon1.defaultImage),
                    Text(pokemon1.name.capitalize()),
                  ],
                ),
              ),

              // Trigger and arrow
              Column(
                children: [
                  const Icon(Icons.arrow_forward),
                  Text(trigger),
                ],
              ),

              // To pokemon
              Expanded(
                child: Column(
                  children: [
                    Image.network(pokemon2.defaultImage),
                    Text(pokemon2.name.capitalize()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow(
      {super.key, required this.label, required this.value, required this.max});

  final String label;
  final int value;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label),
        ),
        SizedBox(
          width: 50,
          child: Text(value.toString()),
        ),
        Expanded(
            child: LinearProgressIndicator(
          value: value / max,
        )),
      ],
    );
  }
}

class MovesTab extends StatelessWidget {
  const MovesTab({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
