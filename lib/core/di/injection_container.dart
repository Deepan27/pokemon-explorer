import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../network/api_client.dart';
import '../database/app_database.dart';
import '../services/image_service.dart';
import '../../features/pokemon_list/data/datasources/pokemon_remote_data_source.dart';
import '../../features/pokemon_list/data/datasources/pokemon_local_data_source.dart';
import '../../features/pokemon_list/data/repositories/pokemon_repository_impl.dart';
import '../../features/pokemon_list/domain/repositories/pokemon_repository.dart';
import '../../features/pokemon_list/presentation/bloc/pokemon_list_bloc.dart';
import '../../features/pokemon_detail/presentation/bloc/pokemon_detail_bloc.dart';
import '../network/connectivity_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => ImageService(sl()));

  // Features - Pokemon List
  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectionChecker: sl(),
    ),
  );

  // Presentation
  sl.registerFactory(() => PokemonListBloc(repository: sl()));
  sl.registerFactory(() => PokemonDetailBloc(repository: sl()));
  sl.registerLazySingleton(() => ConnectivityCubit(connectionChecker: sl()));
}
