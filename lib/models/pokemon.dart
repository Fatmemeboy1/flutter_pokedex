class Pokemon {
  Pokemon({
    required this.abilities,
    required this.baseExperience,
    required this.height,
    required this.id,
    required this.isDefault,
    required this.name,
    required this.species,
    required this.order,
    required this.weight,
    required this.defaultImage,
    required this.shinyImage,
    required this.statInfo,
    required this.types,
  });

  final List<Ability> abilities;
  final int? baseExperience;

  /// Height of the Pokemon in meters.
  final double height;
  final int id;
  final bool isDefault;
  final String name;
  final Species species;
  final int order;

  /// Weight of the Pokemon in kilograms.
  final double weight;
  final String defaultImage;
  final String shinyImage;
  final List<StatInfo> statInfo;
  final List<Type> types;

  static Pokemon fromJson(Map<String, dynamic> json) {
    final abilities = <Ability>[];
    for (final abilityInfo in json['abilities']) {
      final a = Ability(
        name: abilityInfo['ability']['name'],
        url: abilityInfo['ability']['url'],
      );
      abilities.add(a);
    }

    final statInfo = <StatInfo>[];
    for (final stat in json['stats']) {
      final info = StatInfo(
        stat: Stat(
          name: stat['stat']['name'],
          url: stat['stat']['url'],
        ),
        baseStat: stat['base_stat'],
        effort: stat['effort'],
      );
      statInfo.add(info);
    }

    final types = <Type>[];
    for (final typeInfo in json['types']) {
      final type = Type(
        name: typeInfo['type']['name'],
        url: typeInfo['type']['url'],
      );
      types.add(type);
    }

    final officialArtwork = json['sprites']['other']['official-artwork'];
    final frontDefault = officialArtwork['front_default'].toString();
    final frontShiny = officialArtwork['front_shiny'].toString();

    const prefix = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/';

    // ! Handling PokeAPI bug, see https://github.com/PokeAPI/pokeapi/issues/952
    final defaultImg = frontDefault.startsWith(prefix * 2)
        ? frontDefault.replaceFirst(prefix, '')
        : frontDefault;

    final shinyImg = frontShiny.startsWith(prefix * 2)
        ? frontShiny.replaceFirst(prefix, '')
        : frontShiny;

    return Pokemon(
      abilities: abilities,
      baseExperience: json['base_experience'],
      height: json['height'] / 10,
      id: json['id'],
      isDefault: json['is_default'],
      name: json['name'],
      species: Species(
        name: json['species']['name'],
        url: json['species']['url'],
      ),
      order: json['order'],
      weight: json['weight'] / 10,
      defaultImage: defaultImg,
      shinyImage: shinyImg,
      statInfo: statInfo,
      types: types,
    );
  }
}

class Ability {
  Ability({
    required this.name,
    required this.url,
  });
  final String name;
  final String url;
}

class StatInfo {
  StatInfo({
    required this.stat,
    required this.baseStat,
    required this.effort,
  });

  final Stat stat;
  final int baseStat;
  final int effort;
}

class Stat {
  Stat({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;
}

class Type {
  Type({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;
}

class Species {
  Species({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  @override
  String toString() {
    return 'Species{name: $name, url: $url}';
  }
}
