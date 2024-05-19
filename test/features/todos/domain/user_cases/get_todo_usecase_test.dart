import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockTodosRepository extends Mock implements TodosRepositoryAbstract {}

void main() {
  late GetTodoUseCase useCase;
  late MockTodosRepository repository;

  setUp(() {
    repository = MockTodosRepository();
    useCase = GetTodoUseCase(repository: repository);
  });

  test('should return the repo failure', () async {
    when(() => repository.getTodo(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error')));

    final result = await useCase(GetTodoParams(id: 1));

    expect(result, Left(Failure(message: 'error')));
  });

  test('should return todo', () async {
    final json = fixture('todo');
    final todo = TodoModel.fromJson(json);
    when(() => repository.getTodo(any()))
        .thenAnswer((_) async => Right(todo.toEntity()));

    final result = await useCase(GetTodoParams(id: 1));
    verify(() => repository.getTodo(1));
    expect(result, Right(todo.toEntity()));
  });
}
