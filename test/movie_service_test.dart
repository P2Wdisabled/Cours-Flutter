import 'package:flutter_test/flutter_test.dart';
import 'package:tp3/service/movie_service.dart';

void main() {
  group('Movie Model', () {
    test('fromJson creates a valid Movie object', () {
      final json = {
        "title": "Inception",
        "year": 2010,
        "poster": "https://example.com/poster.jpg",
        "description": "Dream within a dream",
      };

      final movie = Movie.fromJson(json);

      expect(movie.title, "Inception");
      expect(movie.year, 2010);
      expect(movie.poster, "https://example.com/poster.jpg");
      expect(movie.description, "Dream within a dream");
    });
  });

  // Note: Testing MovieService.loadLocalMovies() requires widget testing
  // or mocking rootBundle, which is more complex for a basic bonus.
  // The logic inside loadLocalMovies is mainly JSON decoding and mapping,
  // which is implicitly covered by the Movie.fromJson test and standard lib reliability.
}
