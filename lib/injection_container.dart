import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
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

final sl = GetIt.instance;

void init() {
  _login();
  _externals();
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
  sl.registerLazySingleton<AuthRepositoryAbstract>(
      () => AuthRepositoryApi(authProvider: sl(), authManager: sl()));

  // register auth manager
  sl.registerLazySingleton<AuthManagerAbstract>(
      () => AuthManagerLocal(storage: sl()));
  //register auth provider
  sl.registerLazySingleton<AuthProviderAbstract>(
      () => AuthProviderApi(client: sl()));
}

void _externals() {
  //register http client
  sl.registerLazySingleton(() => http.Client());
  //register flutter secure  storage
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
