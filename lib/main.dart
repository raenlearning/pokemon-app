import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/di/injection.dart';
import 'app_route.dart';

import 'features/pokemon/presentation/bloc/pokemon_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoute = AppRoute();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PokemonBloc>()),
        BlocProvider(create: (_) => getIt<PokemonDetailBloc>()),
        BlocProvider(create: (_) => getIt<PokemonMovesBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.convergenceTextTheme(),
        ),

        routerConfig: appRoute.router,

        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
      ),
    );
  }
}