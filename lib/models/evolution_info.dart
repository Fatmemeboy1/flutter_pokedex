import 'dart:convert';

import 'pokemon.dart';

class EvolutionInfo {
  EvolutionInfo({
    required this.species,
    required this.evolvesTo,
    required this.evolutionDetails,
  });

  final Species species;
  final List<EvolutionDetail> evolutionDetails;
  final List<EvolutionInfo> evolvesTo;

  static EvolutionInfo fromJson(Map<String, dynamic> chain) {
    final details = (chain['evolution_details'] as List<dynamic>)
        .map((e) => EvolutionDetail(
              minLevel: e['min_level'],
              minHappiness: e['min_happiness'],
              minBeauty: e['min_beauty'],
              minAffection: e['min_affection'],
              needsOverworldRain: e['needs_overworld_rain'],
              timeOfDay: e['time_of_day'],
              trigger: Trigger(
                name: e['trigger']['name'],
                url: e['trigger']['url'],
              ),
              item: e['item'] == null
                  ? null
                  : EvolutionItem(
                      name: e['item']['name'],
                      url: e['item']['url'],
                    ),
              location: e['location'] == null
                  ? null
                  : EvolutionLocation(
                      name: e['location']['name'],
                      url: e['location']['url'],
                    ),
            ))
        .toList();

    final raw = jsonDecode(jsonEncode(chain['evolves_to'])) as List<dynamic>;
    final evolvesTo = raw.map((e) => EvolutionInfo.fromJson(e)).toList();

    return EvolutionInfo(
      species: Species(
        name: chain['species']['name'],
        url: chain['species']['url'],
      ),
      evolutionDetails: details,
      evolvesTo: evolvesTo,
    );
  }

  @override
  String toString() {
    return 'EvolutionInfo(species: $species\n'
        'evolutionDetails: $evolutionDetails\n'
        'evolvesTo: $evolvesTo)';
  }
}

class EvolutionDetail {
  EvolutionDetail({
    required this.trigger,
    this.minLevel,
    this.minHappiness,
    this.minBeauty,
    this.minAffection,
    this.needsOverworldRain,
    this.timeOfDay,
    this.item,
    this.location,
  });

  final int? minLevel;
  final int? minHappiness;
  final int? minBeauty;
  final int? minAffection;
  final bool? needsOverworldRain;
  final String? timeOfDay;
  final Trigger trigger;
  final EvolutionItem? item;
  final EvolutionLocation? location;

  @override
  String toString() {
    return 'EvolutionDetail(minLevel: $minLevel, minHappiness: $minHappiness, minBeauty: $minBeauty, minAffection: $minAffection, needsOverworldRain: $needsOverworldRain, timeOfDay: $timeOfDay, trigger: $trigger)';
  }
}

class Trigger {
  Trigger({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  @override
  String toString() {
    return 'Trigger(name: $name, url: $url)';
  }
}

class EvolutionItem {
  EvolutionItem({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;
}

class EvolutionLocation {
  EvolutionLocation({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;
}
