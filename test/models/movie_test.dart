import 'package:flutter_test/flutter_test.dart';
import 'package:tp3/models/movie.dart'; // Note: le nom du package dans pubspec.yaml est 'tp3' (voir step 11)

void main() {
  group('MovieListItem Tests', () {
    test('Parse correctement un JSON valide', () {
      final json = {'id': 123, 'title': 'Test Movie', 'year': 2024};

      final movie = MovieListItem.fromJson(json);

      expect(movie.id, 123);
      expect(movie.title, 'Test Movie');
      expect(movie.year, 2024);
    });

    test('Gère les valeurs nulles avec des valeurs par défaut', () {
      final json = {'id': 456};

      final movie = MovieListItem.fromJson(json);

      expect(movie.id, 456);
      expect(movie.title, 'Sans titre');
      expect(movie.year, 0);
    });
  });

  group('Movie Tests', () {
    test('Parse correctement un JSON complet', () {
      final json = {
        'id': 1,
        'title': 'Detailed Movie',
        'plot_overview': 'A great movie',
        'year': 2025,
        'user_rating': 8.5,
        'genre_names': ['Action', 'Drama'],
        'poster': 'https://example.com/poster.jpg',
        'trailer': 'https://youtube.com/watch?v=123',
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 1);
      expect(movie.title, 'Detailed Movie');
      expect(movie.plotOverview, 'A great movie');
      expect(movie.year, 2025);
      expect(movie.userRating, 8.5);
      expect(movie.genreNames, ['Action', 'Drama']);
      expect(movie.poster, 'https://example.com/poster.jpg');
      expect(movie.trailer, 'https://youtube.com/watch?v=123');
    });

    test('Utilise un poster par défaut si null', () {
      final json = {
        'id': 2,
        'title': 'No Poster Movie',
        'plot_overview': '',
        'year': 2020,
        'user_rating': 5.0,
        'genre_names': [],
      };

      final movie = Movie.fromJson(json);
      expect(movie.poster, null);
      expect(movie.posterUrl, 'https://placehold.co/600x400');
    });
  });
}
