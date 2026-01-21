import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp3/models/movie.dart';
import 'package:tp3/pages/movie_list_page.dart';
import 'package:tp3/services/movie_service.dart';

// Mock simple pour les tests
class MockMovieService extends MovieService {
  @override
  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    return [];
  }
}

void main() {
  group('MovieListCard Widget Tests', () {
    testWidgets("Affiche correctement le titre et l'année d'un film", (
      WidgetTester tester,
    ) async {
      final testMovie = MovieListItem(id: 1, title: 'Test Movie', year: 2024);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('Année : 2024'), findsOneWidget);
    });

    testWidgets("Affiche l'icône favorite quand le film est favori", (
      WidgetTester tester,
    ) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Favorite Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: true,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Cherche l'icône avec la couleur rouge (indicatif d'un favori dans notre implémentation)
      final iconFinder = find.byIcon(Icons.favorite);
      expect(iconFinder, findsOneWidget);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, Colors.red);
    });
  });
}
