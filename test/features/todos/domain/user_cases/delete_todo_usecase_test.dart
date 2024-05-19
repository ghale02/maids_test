import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/features/todos/domain/use_cases/delete_todo_usecase.dart';

import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockTodosRepository extends Mock implements TodosRepositoryAbstract {}

void main() {
  late DeleteTodoUsecase useCase;
  late MockTodosRepository repository;
  final json = fixture('todo');
  final todo = TodoModel.fromJson(json);
  setUp(() {
    repository = MockTodosRepository();
    useCase = DeleteTodoUsecase(repository: repository);

    registerFallbackValue(todo.toEntity());
  });

  test('should return the repo failure', () async {
    when(() => repository.deleteTodo(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error')));

    final result = await useCase(DeleteTodoParams(todo: todo.toEntity()));

    expect(result, Left(Failure(message: 'error')));
  });

  test('should return todo', () async {
    when(() => repository.deleteTodo(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(DeleteTodoParams(todo: todo.toEntity()));
    verify(() => repository.deleteTodo(todo.toEntity()));
    expect(result, const Right(null));
  });
}
