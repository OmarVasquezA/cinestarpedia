import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie_screen';
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(
              child: Center(child: CircularProgressIndicator(strokeWidth: 2))));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(movie: movie),
                  childCount: 1))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              FadeInRight(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 5) * 0.55,
                child: Column(
                  children: [
                    Text(movie.title, style: textStyles.titleLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      movie.overview,
                      style: textStyles.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                const SizedBox(width: 3),
                Text(HumanFormats.numberVotes(movie.voteAverage),
                    style: textStyles.bodyMedium
                        ?.copyWith(color: Colors.yellow.shade800)),
                const Spacer(),
                Text(HumanFormats.number(movie.popularity),
                    style: textStyles.bodyMedium)
                //Text('${movie.popularity}', style: textStyle.bodyMedium)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ))
            ],
          ),
        ),
        _ActorByMovie(movieId: movie.id.toString()),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}

class _ActorByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorByMovie = ref.watch(actorsByMovieProvider);

    if (actorByMovie[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }
    final actors = actorByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];

            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(actor.profilePath,
                          height: 180, width: 135, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(actor.name, maxLines: 2),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            );
          }),
    );
  }
}

final isFavoriteProvider = FutureProvider.family((ref, int movieId) async {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return await localStorageRepository
      .isMovieFavorite(movieId); //si esta en faavorit
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () async {
              //  await  ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
              await ref
                  .read(favoriteMoviesProvider.notifier)
                  .toogleFavorite(movie);
              ref.invalidate(isFavoriteProvider(movie.id));
            },
            icon: isFavoriteFuture.when(
              loading: () => const CircularProgressIndicator(strokeWidth: 2),
              data: (isFavorite) => isFavorite
                  ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
              error: (_, __) => throw UnimplementedError(),
            )

            //Icon(Icons.favorite_border)
            // icon: Icon(Icons.favorite_rounded, color: Colors.red,)
            )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //  textAlign: TextAlign.start,
        //),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
            const _CustomGrGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.0, 0.2],
                colors: [Colors.black54, Colors.transparent]),
            const _CustomGrGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1.0],
                colors: [Colors.transparent, Colors.black54]),
            const _CustomGrGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                stops: [
                  0.0,
                  0.25
                ],
                colors: [
                  Colors.black87,
                  Colors.transparent,
                ])
          ],
        ),
      ),
    );
  }
}

class _CustomGrGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGrGradient(
      {required this.begin,
      required this.end,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}
