import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/add_todo_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/add_todo_states.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../fixture.dart';

class MockAddTodoUsecase extends Mock implements AddTodoUsecase {}

void main() {
  late MockAddTodoUsecase usecase;
  final json = fixture('todo');
  final todo = TodoModel.fromJson(json).toEntity();
  setUp(() {
    usecase = MockAddTodoUsecase();
  });

  blocTest<AddTodoCubit, AddTodoState>(
    'should emits [AddTodoLoading,AddTodoFailed] when usecase return failure',
    build: () => AddTodoCubit(usecase),
    setUp: () => when(() => usecase(AddTodoParams(todo: 'todo')))
        .thenAnswer((_) async => Left(Failure(message: 'error'))),
    act: (bloc) => bloc.addTodo('todo'),
    expect: () => [AddTodoLoading(), AddTodoFailed(message: 'error')],
  );
  blocTest<AddTodoCubit, AddTodoState>(
    'should emits [] when state is AddTodoLoading',
    build: () => AddTodoCubit(usecase),
    seed: () => AddTodoLoading(),
    act: (bloc) => bloc.addTodo('todo'),
    expect: () => [],
  );
  blocTest<AddTodoCubit, AddTodoState>(
    'should emits [AddTodoLoading,AddTodoSuccess] when usecase return success',
    build: () => AddTodoCubit(usecase),
    setUp: () => when(() => usecase(AddTodoParams(todo: 'todo')))
        .thenAnswer((_) async => Right(todo)),
    act: (bloc) => bloc.addTodo('todo'),
    expect: () => [AddTodoLoading(), AddTodoSuccess()],
  );
}
