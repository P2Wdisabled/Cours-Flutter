// Modèle simplifié pour la liste des films
class MovieListItem {
  final int id;
  final String title;
  final int year;

  MovieListItem({required this.id, required this.title, required this.year});

  factory MovieListItem.fromJson(Map<String, dynamic> json) {
    return MovieListItem(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      year: json['year'] ?? 0,
    );
  }
}

// Modèle complet pour les détails d'un film
class Movie {
  final int id;
  final String title;
  final String plotOverview;
  final int year;
  final String? poster;
  final String? backdrop;
  final double userRating;
  final List<String> genreNames;
  final String? trailer;

  Movie({
    required this.id,
    required this.title,
    required this.plotOverview,
    required this.year,
    this.poster,
    this.backdrop,
    required this.userRating,
    required this.genreNames,
    this.trailer,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      plotOverview: json['plot_overview'] ?? 'Aucune description disponible',
      year: json['year'] ?? 0,
      poster: json['poster'],
      backdrop: json['backdrop'],
      userRating: (json['user_rating'] ?? 0).toDouble(),
      genreNames:
          (json['genre_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      trailer: json['trailer'],
    );
  }

  String get posterUrl => poster ?? 'https://placehold.co/600x400';

  String get backdropUrl => backdrop ?? 'https://placehold.co/600x400';
}

class MovieSource {
  final String name;
  final String type; // sub, rent, buy, free
  final String? webUrl;

  MovieSource({required this.name, required this.type, this.webUrl});

  factory MovieSource.fromJson(Map<String, dynamic> json) {
    return MovieSource(
      name: json['name'] ?? 'Inconnu',
      type: json['type'] ?? 'unknown',
      webUrl: json['web_url'],
    );
  }
}

class CastMember {
  final String name;
  final String? character;
  final String? photoUrl;
  final String type; // Actor, Director, etc.

  CastMember({
    required this.name,
    this.character,
    this.photoUrl,
    required this.type,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: json['full_name'] ?? json['name'] ?? 'Inconnu',
      character: json['role'],
      photoUrl: json['headshot_url'] ?? json['image_url'],
      type: json['type'] ?? 'unknown',
    );
  }
}
