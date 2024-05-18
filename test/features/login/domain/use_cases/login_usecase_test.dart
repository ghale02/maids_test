import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/repositories/auth_repository_abstract.dart';
import 'package:maids_test/features/login/domain/use_cases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepositoryAbstract {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;
  const username = 'username', password = '123456789';

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository: repository);
  });

  test('when repo return failure', () async {
    when(() => repository.login(username, password))
        .thenAnswer((_) async => Left(Failure(message: 'error')));
    final res =
        await useCase(LoginParams(username: username, password: password));
    expect(res, Left(Failure(message: 'error')));
    verify(() => repository.login(username, password));
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
    when(() => repository.login(username, password))
        .thenAnswer((_) async => Right(entity));
    final res =
        await useCase(LoginParams(username: username, password: password));
    expect(res, Right(entity));
    verify(() => repository.login(username, password));
  });
}
