import 'package:flutter/material.dart';
import 'service/movie_service.dart';

class MovieListPage extends StatefulWidget {
  final MovieService movieService;

  const MovieListPage({super.key, required this.movieService});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<Movie> movies = [];
  final Set<String> favorites = {};
  bool isGridMode = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMovies() async {
    final loadedMovies = await widget.movieService.loadLocalMovies();
    setState(() => movies = loadedMovies);
  }

  void toggleFavorite(String title) {
    setState(() {
      if (favorites.contains(title)) {
        favorites.remove(title);
      } else {
        favorites.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isGridMode
            ? const Text('🎬 Liste de films')
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un film...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
              ),
        actions: [
          IconButton(
            icon: Icon(isGridMode ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => isGridMode = !isGridMode),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesPage(
                  favorites: favorites,
                  movies: movies,
                  toggleFavorite: toggleFavorite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildMovieContent(),
    );
  }

  Widget _buildMovieContent() {
    final filteredMovies = movies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    if (filteredMovies.isEmpty) {
      return const Center(child: Text('Aucun film trouvé'));
    }

    return isGridMode
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) => MovieCard(
              movie: filteredMovies[index],
              isFavorite: favorites.contains(filteredMovies[index].title),
              onFavoriteTap: () => toggleFavorite(filteredMovies[index].title),
              isGrid: true,
            ),
          )
        : ListView.builder(
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) => MovieCard(
              movie: filteredMovies[index],
              isFavorite: favorites.contains(filteredMovies[index].title),
              onFavoriteTap: () => toggleFavorite(filteredMovies[index].title),
            ),
          );
  }
}

class FavoritesPage extends StatelessWidget {
  final Set<String> favorites;
  final List<Movie> movies;
  final Function(String) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.movies,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = movies
        .where((m) => favorites.contains(m.title))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Coups de coeur ❤️')),
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Text(
                'Aucun favori pour le moment.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return MovieCard(
                  movie: movie,
                  isFavorite: true,
                  onFavoriteTap: () => toggleFavorite(movie.title),
                  favoriteIcon: Icons.delete,
                );
              },
            ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData? favoriteIcon;
  final bool isGrid;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.favoriteIcon,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(
              movie: movie,
              isFavorite: isFavorite,
              onFavoriteTap: onFavoriteTap,
            ),
          ),
        ),
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      child: Image.network(
                        movie.poster,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.movie, size: 50),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${movie.year}'),
                            IconButton(
                              icon: Icon(
                                favoriteIcon ??
                                    (isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border),
                                size: 20,
                                color: isFavorite && favoriteIcon == null
                                    ? Colors.red
                                    : null,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: onFavoriteTap,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    movie.poster,
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 75,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie),
                    ),
                  ),
                ),
                title: Text(movie.title),
                subtitle: Text('${movie.year}'),
                trailing: IconButton(
                  icon: Icon(
                    favoriteIcon ??
                        (isFavorite ? Icons.favorite : Icons.favorite_border),
                    color: isFavorite && favoriteIcon == null
                        ? Colors.red
                        : null,
                  ),
                  onPressed: onFavoriteTap,
                ),
              ),
      ),
    );
  }
}

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  final bool initialIsFavorite;
  final VoidCallback onFavoriteTap;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required bool isFavorite,
    required this.onFavoriteTap,
  }) : initialIsFavorite = isFavorite;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialIsFavorite;
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    widget.onFavoriteTap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.movie.poster,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 400,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.movie.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Synopsis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
