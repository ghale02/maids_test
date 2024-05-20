import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/use_cases/delete_todo_usecase.dart';
import 'package:maids_test/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:maids_test/features/todos/domain/use_cases/update_todo_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/todo_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/todo_states.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../fixture.dart';

class MockGetTodoUsecase extends Mock implements GetTodoUseCase {}

class MockUpdateTodoUsecase extends Mock implements UpdateTodoUsecase {}

class MockDeleteTodoUsecase extends Mock implements DeleteTodoUsecase {}

void main() {
  late MockGetTodoUsecase getTodoUsecase;
  late MockUpdateTodoUsecase updateTodoUsecase;
  late MockDeleteTodoUsecase deleteTodoUsecase;
  late TodoCubit cubit;
  final json = fixture('todo');
  final todo = TodoModel.fromJson(json).toEntity();
  setUp(() {
    getTodoUsecase = MockGetTodoUsecase();
    updateTodoUsecase = MockUpdateTodoUsecase();
    deleteTodoUsecase = MockDeleteTodoUsecase();
    cubit = TodoCubit(
      getTodoUsecase: getTodoUsecase,
      updateTodoUsecase: updateTodoUsecase,
      deleteTodoUsecase: deleteTodoUsecase,
    );
  });

  group('getTodo method', () {
    blocTest(
      'should emit [TodoLoading, TodoInitial] when usecase return failure',
      setUp: () => when(() => getTodoUsecase(GetTodoParams(id: 1)))
          .thenAnswer((_) async => Left(Failure(message: 'error'))),
      build: () => cubit,
      act: (cubit) => cubit.getTodo(1),
      expect: () => [TodoLoading(), TodoInitial()],
    );
    blocTest(
      'should emit [TodoLoading, TodoLoaded] when usecase return todo',
      setUp: () => when(() => getTodoUsecase(GetTodoParams(id: 1)))
          .thenAnswer((_) async => Right(todo)),
      build: () => cubit,
      act: (cubit) => cubit.getTodo(1),
      expect: () => [TodoLoading(), TodoLoaded(todo: todo)],
    );
  });

  group('updateTodo method', () {
    blocTest<TodoCubit, TodoState>(
      'should emit [TodoSubmitting, TodoError, TodoLoaded] when usecase return failure',
      setUp: () => when(() => updateTodoUsecase(
              UpdateTodoParams(todo: todo.copyWith(todo: 'updated'))))
          .thenAnswer((_) async => Left(Failure(message: 'error'))),
      build: () => cubit,
      seed: () => TodoLoaded(todo: todo),
      act: (cubit) => cubit.updateTodo(todo.copyWith(todo: 'updated')),
      expect: () => [
        TodoSubmitting(todo: todo),
        TodoError(todo: todo, message: 'error'),
        TodoLoaded(todo: todo)
      ],
    );
    blocTest<TodoCubit, TodoState>(
      'should emit [] when state is TodoSubmitting',
      setUp: () => when(() => updateTodoUsecase(
              UpdateTodoParams(todo: todo.copyWith(todo: 'updated'))))
          .thenAnswer((_) async => Left(Failure(message: 'error'))),
      build: () => cubit,
      seed: () => TodoSubmitting(todo: todo),
      act: (cubit) => cubit.updateTodo(todo.copyWith(todo: 'updated')),
      expect: () => [],
    );
    blocTest<TodoCubit, TodoState>(
      'should emit [TodoSubmitting, TodoLoaded] when usecase return success',
      setUp: () => when(() => updateTodoUsecase(
              UpdateTodoParams(todo: todo.copyWith(todo: 'updated'))))
          .thenAnswer((_) async => const Right(null)),
      build: () => cubit,
      seed: () => TodoLoaded(todo: todo),
      act: (cubit) => cubit.updateTodo(todo.copyWith(todo: 'updated')),
      expect: () => [
        TodoSubmitting(todo: todo),
        TodoLoaded(todo: todo.copyWith(todo: 'updated'))
      ],
    );
  });

  group('deleteTodo method', () {
    blocTest<TodoCubit, TodoState>(
      'should emit [TodoSubmitting, TodoError, TodoLoaded] when usecase return failure',
      setUp: () => when(() => deleteTodoUsecase(DeleteTodoParams(todo: todo)))
          .thenAnswer((_) async => Left(Failure(message: 'error'))),
      build: () => cubit,
      seed: () => TodoLoaded(todo: todo),
      act: (cubit) => cubit.deleteTodo(todo),
      expect: () => [
        TodoSubmitting(todo: todo),
        TodoError(todo: todo, message: 'error'),
        TodoLoaded(todo: todo)
      ],
    );
    blocTest<TodoCubit, TodoState>(
      'should emit [] when state is TodoSubmitting',
      setUp: () => when(() => deleteTodoUsecase(DeleteTodoParams(todo: todo)))
          .thenAnswer((_) async => Left(Failure(message: 'error'))),
      build: () => cubit,
      seed: () => TodoSubmitting(todo: todo),
      act: (cubit) => cubit.deleteTodo(todo),
      expect: () => [],
    );
    blocTest<TodoCubit, TodoState>(
      'should emit [TodoSubmitting, TodoDeleted] when usecase return success',
      setUp: () => when(() => deleteTodoUsecase(DeleteTodoParams(todo: todo)))
          .thenAnswer((_) async => const Right(null)),
      build: () => cubit,
      seed: () => TodoLoaded(todo: todo),
      act: (cubit) => cubit.deleteTodo(todo),
      expect: () => [TodoSubmitting(todo: todo), TodoDeleted()],
    );
  });
}
