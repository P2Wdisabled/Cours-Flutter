import 'package:dio/dio.dart';
import '../models/movie.dart';

class MovieService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.watchmode.com/v1';

  // Cache pour stocker les détails des films afin d'éviter les appels API inutiles
  final Map<int, Movie> _cache = {};

  // Récupère la clé API depuis les variables d'environnement
  static const String _apiKey = String.fromEnvironment(
    'WATCHMODE_API_KEY',
    defaultValue: '',
  );

  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    // Vérifie que la clé API est bien fournie
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app depuis VS Code ou avec --dart-define=WATCHMODE_API_KEY=ta_clé',
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/list-titles/',
        queryParameters: {'apiKey': _apiKey, 'types': 'movie', 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> titles = response.data['titles'];
        return titles.map((json) => MovieListItem.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des films');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    // 1. Vérifier si le film est dans le cache
    if (_cache.containsKey(movieId)) {
      return _cache[movieId]!;
    }

    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app depuis VS Code ou avec --dart-define=WATCHMODE_API_KEY=ta_clé',
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/details/',
        queryParameters: {'apiKey': _apiKey},
      );

      if (response.statusCode == 200) {
        final movie = Movie.fromJson(response.data);
        // 2. Stocker dans le cache
        _cache[movieId] = movie;
        return movie;
      } else {
        throw Exception('Erreur lors du chargement des détails');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<List<MovieSource>> getMovieSources(int movieId) async {
    if (_apiKey.isEmpty) throw Exception('Clé API manquante');

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/sources/',
        queryParameters: {'apiKey': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> sources = response.data;
        final uniqueSources = <String>{};
        return sources
            .map((json) => MovieSource.fromJson(json))
            .where((source) => uniqueSources.add(source.name))
            .toList();
      } else {
        throw Exception('Erreur lors du chargement des sources');
      }
    } catch (e) {
      throw Exception('Erreur réseau (sources) : $e');
    }
  }

  Future<List<CastMember>> getMovieCast(int movieId) async {
    if (_apiKey.isEmpty) throw Exception('Clé API manquante');

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/cast-crew/',
        queryParameters: {'apiKey': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> cast = response.data;
        final uniqueCast = <String>{};
        return cast
            .map((json) => CastMember.fromJson(json))
            .where((member) => uniqueCast.add(member.name))
            .toList();
      } else {
        throw Exception('Erreur lors du chargement du casting');
      }
    } catch (e) {
      throw Exception('Erreur réseau (casting) : $e');
    }
  }
}
