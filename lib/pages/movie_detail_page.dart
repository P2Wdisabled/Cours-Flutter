import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieService movieService;
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieService,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? movie;
  List<MovieSource> sources = [];
  List<CastMember> cast = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllMovieDetails();
  }

  Future<void> _loadAllMovieDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        widget.movieService.getMovieDetails(widget.movieId),
        widget.movieService.getMovieSources(widget.movieId),
        widget.movieService.getMovieCast(widget.movieId),
      ]);

      if (mounted) {
        setState(() {
          movie = results[0] as Movie;
          sources = results[1] as List<MovieSource>;
          cast = results[2] as List<CastMember>;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _openTrailer() async {
    if (movie?.trailer == null) return;

    final uri = Uri.parse(movie!.trailer!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir la bande-annonce'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openSourceUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie?.title ?? 'Chargement...')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAllMovieDetails,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du poster
                  Image.network(
                    movie!.posterUrl,
                    width: double.infinity,
                    height: 500,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 500,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Note et année
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              movie!.userRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '/ 10',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[700],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${movie!.year}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Genres
                        if (movie!.genreNames.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            children: movie!.genreNames
                                .map(
                                  (genre) => Chip(
                                    label: Text(genre),
                                    backgroundColor: Colors.blue[100],
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Plateformes de streaming (Bonus)
                        if (sources.isNotEmpty) ...[
                          const Text(
                            'Disponible sur',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: sources.map((source) {
                              return ActionChip(
                                avatar: const Icon(Icons.tv, size: 16),
                                label: Text('${source.name} (${source.type})'),
                                onPressed: source.webUrl != null
                                    ? () => _openSourceUrl(source.webUrl!)
                                    : null,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Casting (Bonus)
                        if (cast.isNotEmpty) ...[
                          const Text(
                            'Casting',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final member = cast[index];
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: member.photoUrl != null
                                          ? NetworkImage(member.photoUrl!)
                                          : null,
                                      child: member.photoUrl == null
                                          ? Text(member.name[0])
                                          : null,
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        member.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (member.character != null)
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          member.character!,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Synopsis
                        const Text(
                          'Synopsis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie!.plotOverview,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        // Bouton bande-annonce si disponible
                        if (movie!.trailer != null) ...[
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _openTrailer,
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Voir la bande-annonce'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
