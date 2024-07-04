import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/movies/categories_view.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final appRouter =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/', routes: [
  StatefulShellRoute.indexedStack(
    
      builder: (context, state, navigationShell) {
        return CustomBottonNavigationBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(navigatorKey: _sectionNavigatorKey, routes: [
          GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                    path: 'movie/:id',
                    name: MovieScreen.name,
                    builder: (context, state) {
                      final movieId = state.pathParameters['id'] ?? 'no-id';
                      return MovieScreen(movieId: movieId);
                    }),
              ])
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoriesView(),
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesView(),
          )
        ]),
      ])
]);

// final appRouter = GoRouter(initialLocation: '/', routes: [
//   GoRoute(
//     path: '/',
//     name: HomeScreen.name,
//     builder: (context, state) => const HomeScreen(),
//     routes: [
//       GoRoute(
//       path: 'movie/:id',
//       name: MovieScreen.name,
//       builder: (context, state) {
//         final  movieId = state.pathParameters['id'] ?? 'no-id';
//         return  MovieScreen(movieId: movieId);
//       }),
      
//     ]
//   ),
  
// ]);
