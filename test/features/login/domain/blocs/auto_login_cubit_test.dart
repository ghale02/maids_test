import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/use_cases/auto_login_usecase.dart';
import 'package:maids_test/features/login/presentation/blocs/auto_login_cubit.dart';
import 'package:maids_test/features/login/presentation/blocs/auto_login_states.dart';

import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements AutoLoginUseCase {}

void main() {
  late MockLoginUseCase useCase;

  //create user entity
  final userEntity = UserEntity(
    id: 1,
    username: 'username',
    email: 'email',
    firstName: 'firstName',
    lastName: 'lastName',
    gender: 'gender',
    image: 'image',
    token: 'token',
  );

  setUp(() {
    useCase = MockLoginUseCase();

    registerFallbackValue(NoParams());
  });

  blocTest(
    'failed',
    build: () => AutoLoginCubit(useCase: useCase),
    setUp: () => when(() => useCase(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error'))),
    act: (bloc) => bloc.autoLogin(),
    expect: () => [
      AutoLoginInitial(),
      AutoLoginFailed(error: 'error'),
    ],
  );
  blocTest(
    'use case gives AutoLoginFailure',
    build: () => AutoLoginCubit(useCase: useCase),
    setUp: () => when(() => useCase(any()))
        .thenAnswer((_) async => Left(AutoLoginFailure())),
    act: (bloc) => bloc.autoLogin(),
    expect: () => [
      AutoLoginInitial(),
      AutoLoginNotCompleted(),
    ],
  );

  blocTest(
    'success',
    build: () => AutoLoginCubit(useCase: useCase),
    setUp: () =>
        when(() => useCase(any())).thenAnswer((_) async => Right(userEntity)),
    act: (bloc) => bloc.autoLogin(),
    expect: () => [AutoLoginInitial(), AutoLoginSuccess()],
  );
}
