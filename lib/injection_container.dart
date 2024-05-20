import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maids_test/core/app_database.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_abstract.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_local.dart';
import 'package:maids_test/features/login/data/providers/auth_provider_abstract.dart';
import 'package:maids_test/features/login/data/providers/auth_provider_api.dart';
import 'package:maids_test/features/login/data/repositories/auth_repository_api.dart';
import 'package:maids_test/features/login/domain/repositories/auth_repository_abstract.dart';
import 'package:maids_test/features/login/domain/use_cases/auto_login_usecase.dart';
import 'package:maids_test/features/login/domain/use_cases/login_usecase.dart';
import 'package:maids_test/features/login/presentation/blocs/auto_login_cubit.dart';
import 'package:maids_test/features/login/presentation/blocs/login_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_abstract.dart';
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_local.dart';
import 'package:maids_test/features/todos/data/providers/todos_provider_abstract.dart';
import 'package:maids_test/features/todos/data/providers/todos_provider_api.dart';
import 'package:maids_test/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:maids_test/features/todos/domain/use_cases/get_todos_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/add_todo_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/todos_list_cubit.dart';
import 'package:maids_test/shared/providers/connection_checker_abstract.dart';
import 'package:maids_test/shared/providers/connection_checker_impl.dart';
import 'package:sqflite/sqflite.dart';

final sl = GetIt.instance;

void init() {
  _login();
  _todos();
  _externals();
  _shared();
  _database();
}

void _login() {
  // register login cubit
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  //register login usecase as lazy singleton
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  // register auto login cubit
  sl.registerFactory(() => AutoLoginCubit(useCase: sl()));
  //register auto login usecase as lazy singleton
  sl.registerLazySingleton(() => AutoLoginUseCase(repository: sl()));

  // register auth repository
  sl.registerLazySingleton<AuthRepositoryAbstract>(() => AuthRepositoryApi(
      authProvider: sl(), authManager: sl(), connectionChecker: sl()));

  //register auth provider
  sl.registerLazySingleton<AuthProviderAbstract>(
      () => AuthProviderApi(client: sl()));
}

void _shared() {
  // register auth manager
  sl.registerLazySingleton<AuthManagerAbstract>(
      () => AuthManagerLocal(storage: sl()));
  //register connection checker
  sl.registerLazySingleton<ConnectionCheckerAbstract>(
      () => ConnectionCheckerImpl(sl()));
}

void _externals() {
  //register http client
  sl.registerLazySingleton(() => http.Client());
  //register flutter secure  storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

void _todos() {
  // register get todos cubit
  sl.registerFactory(() => TodosListCubit(sl()));
  // register add todo
  sl.registerFactory(() => AddTodoCubit(sl()));
  //register get todos usecase as lazy singleton
  sl.registerLazySingleton(() => GetTodosUseCase(repository: sl()));
  //register add todo usecase
  sl.registerLazySingleton(() => AddTodoUsecase(repository: sl()));

  // register todos repository
  sl.registerLazySingleton<TodosRepositoryAbstract>(() => TodoRepositoryImpl(
        apiProvider: sl(),
        authManager: sl(),
        cache: sl(),
        connectionChecker: sl(),
      ));
  //register todos api provider
  sl.registerLazySingleton<TodosProviderAbstract>(
      () => TodosProviderApi(client: sl()));
  //register todos cache provider
  sl.registerLazySingleton<TodosCacheProviderAbstract>(
      () => TodosCacheProviderLocal(database: sl()));
}

void _database() async {
  final Database database = await AppDatabase.instance;
  sl.registerLazySingleton<Database>(() => database);
}
