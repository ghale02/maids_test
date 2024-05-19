import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';

class DeleteTodoUsecase extends UseCase<DeleteTodoParams, void> {
  final TodosRepositoryAbstract repository;

  DeleteTodoUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteTodoParams params) async {
    return await repository.deleteTodo(params.todo);
  }
}

class DeleteTodoParams {
  final TodoEntity todo;
  DeleteTodoParams({
    required this.todo,
  });
}
