import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
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

class DeleteTodoParams extends Equatable {
  final TodoEntity todo;
  const DeleteTodoParams({
    required this.todo,
  });

  @override
  List<Object> get props => [todo];
}
