import 'package:dartz/dartz.dart';

import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/data/models/user_model.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_abstract.dart';
import 'package:maids_test/features/login/data/providers/auth_provider_abstract.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/repositories/auth_repository_abstract.dart';
import 'package:maids_test/shared/providers/connection_checker_abstract.dart';

class AuthRepositoryApi extends AuthRepositoryAbstract {
  final AuthProviderAbstract authProvider;
  final AuthManagerAbstract authManager;
  final ConnectionCheckerAbstract connectionChecker;

  AuthRepositoryApi({
    required this.authProvider,
    required this.authManager,
    required this.connectionChecker,
  });
  @override
  Future<Either<Failure, UserEntity>> login(
      String username, String password) async {
    try {
      if (await connectionChecker.isConnected == false) {
        return Left(NoInternetFailure());
      }

      final UserModel res = await authProvider.login(username, password);
      // save user in the local storage
      await authManager.setUser(res);
      //convert the model to entity
      UserEntity user = UserEntity(
        id: res.id,
        username: res.username,
        email: res.email,
        firstName: res.firstName,
        lastName: res.lastName,
        gender: res.gender,
        image: res.image,
        token: res.token,
      );
      //return the entity
      return Right(user);
    } on BaseException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      final UserModel res = await authManager.getUser();

      //convert the model to entity
      UserEntity user = UserEntity(
        id: res.id,
        username: res.username,
        email: res.email,
        firstName: res.firstName,
        lastName: res.lastName,
        gender: res.gender,
        image: res.image,
        token: res.token,
      );
      //return the entity
      return Right(user);
    } on NoUserFound {
      return Left(AutoLoginFailure());
    } on BaseException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
