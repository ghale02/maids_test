import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';

class AddTodoUsecase extends UseCase<AddTodoParams, TodoEntity> {
  final TodosRepositoryAbstract repository;

  AddTodoUsecase({required this.repository});

  @override
  Future<Either<Failure, TodoEntity>> call(AddTodoParams params) async {
    return await repository.addTodo(
        TodoEntity(id: 0, todo: params.todo, completed: false, userId: 0));
  }
}

class AddTodoParams extends Equatable {
  final String todo;
  AddTodoParams({
    required this.todo,
  });

  @override
  List<Object?> get props => [todo];
}
