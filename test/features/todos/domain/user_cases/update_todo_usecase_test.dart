import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/features/todos/domain/use_cases/update_todo_usecase.dart';

import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockTodosRepository extends Mock implements TodosRepositoryAbstract {}

void main() {
  late UpdateTodoUsecase useCase;
  late MockTodosRepository repository;
  final json = fixture('todo');
  final todo = TodoModel.fromJson(json);
  setUp(() {
    repository = MockTodosRepository();
    useCase = UpdateTodoUsecase(repository: repository);

    registerFallbackValue(todo.toEntity());
  });

  test('should return the repo failure', () async {
    when(() => repository.updateTodo(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error')));

    final result = await useCase(UpdateTodoParams(todo: todo.toEntity()));

    expect(result, Left(Failure(message: 'error')));
  });

  test('should return todo', () async {
    when(() => repository.updateTodo(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(UpdateTodoParams(todo: todo.toEntity()));
    verify(() => repository.updateTodo(todo.toEntity()));
    expect(result, const Right(null));
  });
}
