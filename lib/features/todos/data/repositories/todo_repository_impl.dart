import 'package:dartz/dartz.dart';
import 'package:maids_test/core/debug.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_abstract.dart';
import 'package:maids_test/features/todos/data/mappers/todo_list_mapper.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_abstract.dart';
import 'package:maids_test/features/todos/data/providers/todos_provider_abstract.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';
import 'package:maids_test/features/todos/domain/entities/todos_list_entity.dart';
import 'package:maids_test/features/todos/domain/repositories/todos_repository_abstract.dart';
import 'package:maids_test/shared/providers/connection_checker_abstract.dart';

class TodoRepositoryImpl extends TodosRepositoryAbstract {
  final TodosProviderAbstract apiProvider;
  final ConnectionCheckerAbstract connectionChecker;
  final AuthManagerAbstract authManager;
  final TodosCacheProviderAbstract cache;
  TodoRepositoryImpl({
    required this.apiProvider,
    required this.connectionChecker,
    required this.authManager,
    required this.cache,
  });

  @override
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todo) async {
    try {
      if (await connectionChecker.isConnected == false) {
        return Left(NoInternetFailure());
      }

      final newTodo = await apiProvider.addTodo(todo.toModel());
      return Right(newTodo.toEntity());
    } on BaseException catch (e) {
      debugPrint(e);
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(TodoEntity todo) async {
    try {
      if (await connectionChecker.isConnected == false) {
        return Left(NoInternetFailure());
      }
      await apiProvider.deleteTodo(todo.toModel());
      return const Right(null);
    } on BaseException catch (e) {
      debugPrint(e);
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> getTodo(int id) async {
    try {
      //check internet connection
      if (await connectionChecker.isConnected) {
        final todo = await apiProvider.getTodo(id);
        return Right(todo.toEntity());
      } else {
        try {
          final todo = await cache.getTodo(id);
          return Right(todo.toEntity());
        } on NotFoundException {
          return Left(NoInternetFailure());
        }
      }
    } on BaseException catch (e) {
      debugPrint(e);
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, TodosListEntity>> getTodos(int skip) async {
    try {
      //check internet connection
      if (await connectionChecker.isConnected) {
        //get data from the api
        final todos = await apiProvider.getTodos(skip);
        //cache the data
        await cache.cacheTodos(todos);
        return Right(todos.toEntity());
      } else {
        // no internet connection
        try {
          //get the data from the cache
          final todos = await cache.getTodos(skip);
          return Right(todos.toEntity());
        } on NoTodosException {
          //if no data in the cache return no internet failure
          return Left(NoInternetFailure());
        }
      }
    } on BaseException catch (e) {
      print(e);
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(TodoEntity todo) async {
    try {
      if (await connectionChecker.isConnected == false) {
        return Left(NoInternetFailure());
      }
      await apiProvider.updateTodo(todo.toModel());
      return const Right(null);
    } on BaseException catch (e) {
      debugPrint(e);
      return Left(Failure(message: e.message));
    }
  }
}
