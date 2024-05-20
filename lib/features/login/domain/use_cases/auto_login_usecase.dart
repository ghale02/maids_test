import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/repositories/auth_repository_abstract.dart';

class AutoLoginUseCase extends UseCase<NoParams, UserEntity> {
  final AuthRepositoryAbstract repository;
  AutoLoginUseCase({required this.repository});
  @override
  Future<Either<Failure, UserEntity>> call(NoParams input) {
    return repository.getUser();
  }
}
