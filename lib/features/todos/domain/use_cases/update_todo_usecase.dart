import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';

class UpdateTodoUsecase extends UseCase<UpdateTodoParams, void> {
  final TodosRepositoryAbstract repository;

  UpdateTodoUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateTodoParams params) async {
    return await repository.updateTodo(params.todo);
  }
}

class UpdateTodoParams {
  final TodoEntity todo;
  UpdateTodoParams({
    required this.todo,
  });
}
