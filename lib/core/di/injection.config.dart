// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokemon_app/core/di/register_module.dart' as _i1026;
import 'package:pokemon_app/features/pokemon/data/data_sources/pokemon_remote_datasource.dart'
    as _i60;
import 'package:pokemon_app/features/pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i626;
import 'package:pokemon_app/features/pokemon/domain/repositories/pokemon_repository.dart'
    as _i33;
import 'package:pokemon_app/features/pokemon/domain/usecases/get_pokemon_detail.dart'
    as _i413;
import 'package:pokemon_app/features/pokemon/domain/usecases/get_pokemon_list.dart'
    as _i69;
import 'package:pokemon_app/features/pokemon/domain/usecases/get_pokemon_moves.dart'
    as _i825;
import 'package:pokemon_app/features/pokemon/presentation/bloc/pokemon_bloc.dart'
    as _i758;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i60.PokemonRemoteDataSource>(
      () => _i60.PokemonRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i33.PokemonRepository>(
      () => _i626.PokemonRepositoryImpl(gh<_i60.PokemonRemoteDataSource>()),
    );
    gh.lazySingleton<_i413.GetPokemonDetail>(
      () => _i413.GetPokemonDetail(gh<_i33.PokemonRepository>()),
    );
    gh.lazySingleton<_i69.GetPokemonList>(
      () => _i69.GetPokemonList(gh<_i33.PokemonRepository>()),
    );
    gh.lazySingleton<_i825.GetPokemonMoves>(
      () => _i825.GetPokemonMoves(gh<_i33.PokemonRepository>()),
    );
    gh.factory<_i758.PokemonDetailBloc>(
      () => _i758.PokemonDetailBloc(gh<_i413.GetPokemonDetail>()),
    );
    gh.factory<_i758.PokemonMovesBloc>(
      () => _i758.PokemonMovesBloc(gh<_i825.GetPokemonMoves>()),
    );
    gh.factory<_i758.PokemonBloc>(
      () => _i758.PokemonBloc(gh<_i69.GetPokemonList>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i1026.RegisterModule {}
