import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';

class GetTodoUseCase extends UseCase<GetTodoParams, TodoEntity> {
  final TodosRepositoryAbstract repository;

  GetTodoUseCase({required this.repository});

  @override
  Future<Either<Failure, TodoEntity>> call(GetTodoParams params) async {
    return await repository.getTodo(params.id);
  }
}

class GetTodoParams {
  final int id;
  GetTodoParams({
    required this.id,
  });
}
