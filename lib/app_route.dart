import 'package:go_router/go_router.dart';
import 'package:pokemon_app/features/pokemon/presentation/pages/home_page.dart';
import 'package:pokemon_app/features/pokemon/presentation/pages/pokemon_detail_page.dart';
import 'package:pokemon_app/features/pokemon/presentation/pages/pokemon_moves_page.dart';
import 'package:pokemon_app/features/pokemon/presentation/pages/splash_screen.dart';


// GoRoute Configuration
class AppRoute {
  final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return PokemonDetailPage(id: id);
          },
          routes: [
            GoRoute(
              path: 'moves',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return PokemonMovesPage(id: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
}