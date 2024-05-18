import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/repositories/auth_repository_abstract.dart';

class LoginUseCase extends UseCase<LoginParams, UserEntity> {
  final AuthRepositoryAbstract repository;
  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LoginParams {
  final String username;
  final String password;
  LoginParams({required this.username, required this.password});
}
