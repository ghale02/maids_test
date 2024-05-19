import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/data/mappers/todo_list_mapper.dart';
import 'package:maids_test/features/todos/data/models/todo_list_model.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/features/todos/domain/use_cases/get_todos_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockTodosRepository extends Mock implements TodosRepositoryAbstract {}

void main() {
  late GetTodosUseCase useCase;
  late MockTodosRepository repository;

  setUp(() {
    repository = MockTodosRepository();
    useCase = GetTodosUseCase(repository: repository);
  });

  test('should return the repo failure', () async {
    when(() => repository.getTodos(any()))
        .thenAnswer((_) async => Left(Failure(message: 'error')));

    final result = await useCase.call(const GetTodosParams(skip: 0));

    expect(result, Left(Failure(message: 'error')));
  });

  test('should return todos list', () async {
    final json = fixture('todos_list');
    final todosList = TodosListModel.fromJson(json);
    when(() => repository.getTodos(any()))
        .thenAnswer((_) async => Right(todosList.toEntity()));

    final result = await useCase.call(const GetTodosParams(skip: 20));
    verify(() => repository.getTodos(20));
    expect(result, Right(todosList.toEntity()));
  });
}
