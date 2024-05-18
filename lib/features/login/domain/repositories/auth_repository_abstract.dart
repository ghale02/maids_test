import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';

abstract class AuthRepositoryAbstract {
  Future<Either<Failure, UserEntity>> login(
    String username,
    String password,
  );

  Future<Either<Failure, UserEntity>> refreshToken();
}
