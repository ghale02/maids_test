import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/domain/entities/user_entity.dart';
import 'package:maids_test/features/login/domain/use_cases/login_usecase.dart';
import 'package:maids_test/features/login/presentation/blocs/login_cubit.dart';
import 'package:maids_test/features/login/presentation/blocs/login_states.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase useCase;
  late LoginCubit cubit;
  const username = 'username', password = '123456789';
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
    cubit = LoginCubit(loginUseCase: useCase);
    registerFallbackValue(LoginParams(username: username, password: password));
  });

  blocTest(
    'should emit LoginFailed when login failed',
    build: () => cubit,
    setUp: () => when(() => useCase(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error'))),
    act: (bloc) => bloc.login(username, password),
    expect: () => [LoginLoading(), LoginFailed(error: 'error')],
  );
  blocTest<LoginCubit, LoginState>(
    'should not submit while the state is loading',
    build: () => cubit,
    seed: () => LoginLoading(),
    setUp: () => when(() => useCase(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error'))),
    act: (bloc) => bloc.login(username, password),
    expect: () => [],
  );

  blocTest(
    'should emit LoginSuccess when login success',
    build: () => cubit,
    setUp: () =>
        when(() => useCase(any())).thenAnswer((_) async => Right(userEntity)),
    act: (bloc) => bloc.login(username, password),
    expect: () => [LoginLoading(), LoginSuccess()],
  );
}
