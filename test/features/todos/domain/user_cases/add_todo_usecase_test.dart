import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockTodosRepository extends Mock implements TodosRepositoryAbstract {}

void main() {
  late AddTodoUsecase useCase;
  late MockTodosRepository repository;
  setUp(() {
    repository = MockTodosRepository();
    useCase = AddTodoUsecase(repository: repository);

    registerFallbackValue(
        const TodoEntity(id: 1, todo: 'test', completed: false, userId: 0));
  });

  test('should return the repo failure', () async {
    when(() => repository.addTodo(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error')));

    final result = await useCase(AddTodoParams(todo: 'test'));

    expect(result, Left(Failure(message: 'error')));
  });

  test('should return todo', () async {
    final json = fixture('todo');
    final todo = TodoModel.fromJson(json);
    when(() => repository.addTodo(any()))
        .thenAnswer((_) async => Right(todo.toEntity()));

    final result = await useCase(AddTodoParams(todo: 'test'));
    verify(() => repository.addTodo(
        const TodoEntity(id: 0, todo: 'test', completed: false, userId: 0)));
    expect(result, Right(todo.toEntity()));
  });
}
