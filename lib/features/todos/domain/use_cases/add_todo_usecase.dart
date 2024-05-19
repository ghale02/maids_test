import 'package:dartz/dartz.dart';

import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';

class AddTodoUsecase extends UseCase<AddTodoParams, TodoEntity> {
  final TodosRepositoryAbstract repository;

  AddTodoUsecase({required this.repository});

  @override
  Future<Either<Failure, TodoEntity>> call(AddTodoParams params) async {
    return await repository.addTodo(TodoEntity(
        id: params.id,
        todo: params.todo,
        completed: params.completed,
        userId: 0));
  }
}

class AddTodoParams {
  final int id;
  final String todo;
  final bool completed;
  AddTodoParams({
    required this.id,
    required this.todo,
    required this.completed,
  });
}
