import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';

import '../models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: (movieDB.backdropPath != '')
        ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnzW3ILRSb_0WazEX6R5S4G0UKXKXDQx4-hg&usqp=CAU',
      genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: (movieDB.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
        : 'https://ih1.redbubble.net/image.5098928927.2456/fposter,small,wall_texture,square_product,600x600.u2.jpg',
      releaseDate: movieDB.releaseDate != null ? movieDB.releaseDate! : DateTime.now(),
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount
      );


static Movie movieDetailsToEntity(MovieDetails movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: (movieDB.backdropPath != '')
        ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnzW3ILRSb_0WazEX6R5S4G0UKXKXDQx4-hg&usqp=CAU',
      genreIds: movieDB.genres.map((e) => e.name).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: (movieDB.posterPath != '')
        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
        : 'https://ih1.redbubble.net/image.5098928927.2456/fposter,small,wall_texture,square_product,600x600.u2.jpg',
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount
      );
      
}


