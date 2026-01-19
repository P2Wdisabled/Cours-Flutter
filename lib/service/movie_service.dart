import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Movie {
  final String title;
  final int year;
  final String poster;
  final String description;

  Movie({
    required this.title,
    required this.year,
    required this.poster,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      year: json['year'] as int,
      poster: json['poster'] as String,
      description: json['description'] as String,
    );
  }
}

class MovieService {
  Future<List<Movie>> loadLocalMovies() async {
    final data = await rootBundle.loadString('assets/data/movies.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }
}
