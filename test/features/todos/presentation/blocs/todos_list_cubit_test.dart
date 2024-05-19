import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_list_mapper.dart';
import 'package:maids_test/features/todos/data/models/todo_list_model.dart';
import 'package:maids_test/features/todos/domain/use_cases/get_todos_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/todos_list_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/todos_list_states.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture.dart';

class MockGetTodosUsecase extends Mock implements GetTodosUseCase {}

void main() {
  late MockGetTodosUsecase useCase;
  setUp(() => useCase = MockGetTodosUsecase());
  final json = fixture('todos_list');
  final todos = TodosListModel.fromJson(json).toEntity();
  blocTest(
    'when usecase return failure on first load',
    build: () {
      final cubit = TodosListCubit(useCase);
      return cubit;
    },
    setUp: () => when(() => useCase(const GetTodosParams(skip: 0)))
        .thenAnswer((_) async => Left(Failure(message: 'message'))),
    act: (bloc) => bloc.load(),
    expect: () => [
      TodosListLoading(),
      TodosListInitial(),
    ],
  );

  blocTest(
    'when usecase return list on first load',
    build: () {
      final cubit = TodosListCubit(useCase);
      return cubit;
    },
    setUp: () => when(() => useCase(const GetTodosParams(skip: 0)))
        .thenAnswer((_) async => Right(todos)),
    act: (bloc) => bloc.load(),
    expect: () => [
      TodosListLoading(),
      TodosListLoaded(todos: todos, skip: 20),
    ],
  );

  blocTest<TodosListCubit, TodosListState>(
    'when usecase return list after first load',
    build: () {
      final cubit = TodosListCubit(useCase);
      return cubit;
    },
    seed: () => TodosListLoaded(todos: todos, skip: 20),
    setUp: () => when(() => useCase(const GetTodosParams(skip: 20)))
        .thenAnswer((_) async => Right(todos)),
    act: (bloc) => bloc.load(),
    expect: () => [
      TodosListLoading(),
      TodosListLoaded(todos: todos.merge(todos), skip: 40),
    ],
  );

  blocTest<TodosListCubit, TodosListState>(
    'should not load more after load all todos',
    build: () {
      final cubit = TodosListCubit(useCase);
      return cubit;
    },
    seed: () => TodosListLoaded(todos: todos, skip: todos.total),
    setUp: () => registerFallbackValue(const GetTodosParams(skip: 0)),
    verify: (bloc) => verifyNever(() => useCase(any())),
    act: (bloc) => bloc.load(),
    expect: () => [],
  );
}
