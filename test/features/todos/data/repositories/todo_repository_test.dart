import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_abstract.dart';
import 'package:maids_test/features/todos/data/mappers/todo_list_mapper.dart';
import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_list_model.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_abstract.dart';
import 'package:maids_test/features/todos/data/providers/todos_provider_abstract.dart';
import 'package:maids_test/shared/providers/connection_checker_abstract.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maids_test/features/todos/data/repositories/todo_repository_impl.dart';

import '../../../../fixture.dart';

class MockTodosCache extends Mock implements TodosCacheProviderAbstract {}

class MockTodosProviderApi extends Mock implements TodosProviderAbstract {}

class MockAuthManager extends Mock implements AuthManagerAbstract {}

class MockConnectionChecker extends Mock implements ConnectionCheckerAbstract {}

void main() {
  late MockTodosCache cache;
  late MockTodosProviderApi api;
  late MockAuthManager authManager;
  late MockConnectionChecker connectionChecker;
  late TodoRepositoryImpl repository;
  final json = fixture('todo');
  final todo = TodoModel.fromJson(json);

  setUp(() {
    cache = MockTodosCache();
    api = MockTodosProviderApi();
    authManager = MockAuthManager();
    connectionChecker = MockConnectionChecker();
    repository = TodoRepositoryImpl(
      cache: cache,
      apiProvider: api,
      authManager: authManager,
      connectionChecker: connectionChecker,
    );
  });

  group('getTodos method', () {
    final json = fixture('todos_list');
    const skip = 20;
    final todosList = TodosListModel.fromJson(json);
    setUp(() => when(() => connectionChecker.isConnected)
        .thenAnswer((_) async => false));
    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => cache.getTodos(0)).thenThrow(e);
      final result = await repository.getTodos(0);
      expect(result, Left(Failure(message: e.message)));
    });

    test('should check the internet connection', () async {
      when(() => cache.getTodos(any())).thenAnswer((_) async => todosList);

      await repository.getTodos(0);
      verify(() => connectionChecker.isConnected);
    });

    group('Internet connection available ', () {
      setUp(() {
        when(() => connectionChecker.isConnected).thenAnswer((_) async => true);
      });

      test('should return todos list from api provider and cache id', () async {
        when(() => api.getTodos(any())).thenAnswer((_) async => todosList);
        when(() => cache.cacheTodos(todosList)).thenAnswer((_) async {});

        final result = await repository.getTodos(skip);
        verify(() => api.getTodos(skip));
        verifyNever(() => cache.getTodos(any()));
        verify(() => cache.cacheTodos(todosList));
        expect(result, Right(todosList.toEntity()));
      });
    });

    group('Internet connection not available ', () {
      setUp(() {
        when(() => connectionChecker.isConnected)
            .thenAnswer((_) async => false);
      });
      test('should get the list from cache', () async {
        when(() => cache.getTodos(any())).thenAnswer((_) async => todosList);

        final result = await repository.getTodos(skip);

        verifyNever(() => api.getTodos(any()));
        verify(() => cache.getTodos(skip));
        expect(result, Right(todosList.toEntity()));
      });

      test('should return NoInternetFailure when cache throw NoTodosException',
          () async {
        when(() => cache.getTodos(any())).thenThrow(NoTodosException());

        final result = await repository.getTodos(skip);
        expect(result, Left(NoInternetFailure()));
      });
    });
  });

  group('getTodo method', () {
    const id = 1;
    setUp(() => when(() => connectionChecker.isConnected)
        .thenAnswer((_) async => false));
    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => cache.getTodo(id)).thenThrow(e);
      final result = await repository.getTodo(id);
      expect(result, Left(Failure(message: e.message)));
    });

    test('should check the internet connection', () async {
      when(() => cache.getTodo(id)).thenAnswer((_) async => todo);

      await repository.getTodo(id);
      verify(() => connectionChecker.isConnected);
    });

    group('Internet connection available ', () {
      setUp(() {
        when(() => connectionChecker.isConnected).thenAnswer((_) async => true);
      });

      test('should return todo from api provider ', () async {
        when(() => api.getTodo(id)).thenAnswer((_) async => todo);

        final result = await repository.getTodo(id);

        verify(() => api.getTodo(id));
        verifyNever(() => cache.getTodo(id));
        expect(result, Right(todo.toEntity()));
      });
    });

    group('Internet connection not available ', () {
      setUp(() {
        when(() => connectionChecker.isConnected)
            .thenAnswer((_) async => false);
      });
      test('should get the todo from cache', () async {
        when(() => cache.getTodo(id)).thenAnswer((_) async => todo);

        final result = await repository.getTodo(id);

        verifyNever(() => api.getTodo(id));
        verify(() => cache.getTodo(id));
        expect(result, Right(todo.toEntity()));
      });

      test('should return NoInternetFailure when cache throw NotFoundException',
          () async {
        when(() => cache.getTodo(id)).thenThrow(NotFoundException());

        final result = await repository.getTodo(id);
        expect(result, Left(NoInternetFailure()));
      });
    });
  });

  group('addTodo method', () {
    setUp(() => when(() => connectionChecker.isConnected)
        .thenAnswer((_) async => true));

    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => api.addTodo(todo)).thenThrow(e);

      final result = await repository.addTodo(todo.toEntity());

      expect(result, Left(Failure(message: e.message)));
    });
    test('should return  NoInternetFailure when no internet', () async {
      when(() => connectionChecker.isConnected).thenAnswer((_) async => false);
      final result = await repository.addTodo(todo.toEntity());
      verify(() => connectionChecker.isConnected);

      expect(result, Left(NoInternetFailure()));
    });
    test('should return todo when add done successfully', () async {
      final entity = todo.toEntity();
      when(() => api.addTodo(todo)).thenAnswer((_) async => todo);

      final result = await repository.addTodo(entity);
      expect(result, Right(entity));
    });
  });

  group('updateTodo method', () {
    setUp(() => when(() => connectionChecker.isConnected)
        .thenAnswer((_) async => true));

    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => api.updateTodo(todo)).thenThrow(e);

      final result = await repository.updateTodo(todo.toEntity());

      expect(result, Left(Failure(message: e.message)));
    });
    test('should return  NoInternetFailure when no internet', () async {
      when(() => connectionChecker.isConnected).thenAnswer((_) async => false);
      final result = await repository.updateTodo(todo.toEntity());
      verify(() => connectionChecker.isConnected);

      expect(result, Left(NoInternetFailure()));
    });
    test('should return update done successfully', () async {
      final entity = todo.toEntity();
      when(() => api.updateTodo(todo)).thenAnswer((_) async {});

      final result = await repository.updateTodo(entity);
      expect(result, const Right(null));
    });
  });

  group('deleteTodo method', () {
    setUp(() => when(() => connectionChecker.isConnected)
        .thenAnswer((_) async => true));

    test('should convert exception to failure', () async {
      final e = ServerException();
      when(() => api.deleteTodo(todo)).thenThrow(e);

      final result = await repository.deleteTodo(todo.toEntity());

      expect(result, Left(Failure(message: e.message)));
    });
    test('should return  NoInternetFailure when no internet', () async {
      when(() => connectionChecker.isConnected).thenAnswer((_) async => false);
      final result = await repository.deleteTodo(todo.toEntity());
      verify(() => connectionChecker.isConnected);

      expect(result, Left(NoInternetFailure()));
    });
    test('should return delete done successfully', () async {
      final entity = todo.toEntity();
      when(() => api.deleteTodo(todo)).thenAnswer((_) async {});

      final result = await repository.deleteTodo(entity);
      expect(result, const Right(null));
    });
  });
}
