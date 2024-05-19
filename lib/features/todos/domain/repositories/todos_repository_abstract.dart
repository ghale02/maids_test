import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/entities/todos_list_entity.dart';

abstract class TodosRepositoryAbstract {
  Future<Either<Failure, TodosListEntity>> getTodos(int skip);
  Future<Either<Failure, TodoEntity>> getTodo(int id);
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todo);
  Future<Either<Failure, void>> updateTodo(TodoEntity todo);
  Future<Either<Failure, void>> deleteTodo(TodoEntity todo);
}
