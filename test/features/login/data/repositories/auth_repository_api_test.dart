import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/data/models/user_model.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_abstract.dart';
import 'package:maids_test/features/login/data/providers/auth_provider_abstract.dart';
import 'package:maids_test/features/login/data/repositories/auth_repository_api.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/shared/providers/connection_checker_abstract.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockAuthProvider extends Mock implements AuthProviderAbstract {}

class MockAuthManager extends Mock implements AuthManagerAbstract {}

class MockConnectionChecker extends Mock implements ConnectionCheckerAbstract {}

void main() {
  late MockAuthProvider authProvider;
  late MockAuthManager authManager;
  late MockConnectionChecker connectionChecker;
  late AuthRepositoryApi repository;

  const username = 'username', password = '123456789';

  setUp(() {
    authProvider = MockAuthProvider();
    authManager = MockAuthManager();
    connectionChecker = MockConnectionChecker();

    when(() => connectionChecker.isConnected).thenAnswer((_) async => true);

    repository = AuthRepositoryApi(
        authProvider: authProvider,
        authManager: authManager,
        connectionChecker: connectionChecker);
  });

  group('login', () {
    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => authProvider.login(username, password)).thenThrow(e);
      final res = await repository.login(username, password);
      expect(res, Left(Failure(message: e.message)));
    });

    test('should return NoInternetFailure if connection is not available',
        () async {
      when(() => connectionChecker.isConnected).thenAnswer((_) async => false);
      final res = await repository.login(username, password);
      expect(res, Left(NoInternetFailure()));
    });

    test('should return UserEntity when login is successful', () async {
      //build user model from user fixture
      final user = UserModel.fromJson(fixture('user'));
      //convert the model to entity
      final userEntity = UserEntity(
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        gender: user.gender,
        image: user.image,
        token: user.token,
      );
      when(() => authProvider.login(username, password))
          .thenAnswer((_) async => user);
      when(() => authManager.setUser(user)).thenAnswer((_) async {});

      final res = await repository.login(username, password);
      verify(() => authProvider.login(username, password));
      verify(() => authManager.setUser(user));
      expect(res, Right(userEntity));
    });
  });

  group('getUser method', () {
    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => authManager.getUser()).thenThrow(e);

      final res = await repository.getUser();
      expect(res, Left(Failure(message: e.message)));
    });
    test('should return AutoLoginFailure when manager throw NoUserFound',
        () async {
      final e = NoUserFound();
      when(() => authManager.getUser()).thenThrow(e);
      final res = await repository.getUser();
      expect(res, Left(AutoLoginFailure()));
    });

    test('should return user entity when authManager return user model',
        () async {
      //build user model from user fixture
      final user = UserModel.fromJson(fixture('user'));
      //convert the model to entity
      final userEntity = UserEntity(
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        gender: user.gender,
        image: user.image,
        token: user.token,
      );
      when(() => authManager.getUser()).thenAnswer((_) async => user);

      final res = await repository.getUser();
      verify(() => authManager.getUser()).called(1);
      expect(res, Right(userEntity));
    });
  });
}
