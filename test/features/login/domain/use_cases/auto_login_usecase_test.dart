import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/repositories/auth_repository_abstract.dart';
import 'package:maids_test/features/login/domain/use_cases/auto_login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepositoryAbstract {}

void main() {
  late MockAuthRepository repository;
  late AutoLoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = AutoLoginUseCase(repository: repository);
  });

  test('when repo return failure', () async {
    when(() => repository.refreshToken())
        .thenAnswer((_) async => Left(Failure(message: 'error')));
    final res = await useCase(NoParams());
    expect(res, Left(Failure(message: 'error')));
  });
  test('when repo return AutoLoginFailure', () async {
    when(() => repository.refreshToken())
        .thenAnswer((_) async => Left(AutoLoginFailure()));
    final res = await useCase(NoParams());
    expect(res, Left(AutoLoginFailure()));
  });
  test('when repo return entity successfully', () async {
    // create entity
    final entity = UserEntity(
      id: 1,
      username: 'username',
      email: 'email',
      firstName: 'firstName',
      lastName: 'lastName',
      gender: 'gender',
      image: 'image',
      token: 'token',
    );
    when(() => repository.refreshToken())
        .thenAnswer((_) async => Right(entity));
    final res = await useCase(NoParams());
    expect(res, Right(entity));
    verify(() => repository.refreshToken());
  });
}
