import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/todos/data/models/todo.dart';
import 'package:maids_test/features/todos/data/models/todo_list.dart';
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../fixture.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late MockDatabase database;
  late TodosCacheProviderLocal provider;
  final todosListJson = fixture('todos_list');
  final todosList = TodosListModel.fromJson(todosListJson);

  setUp(() {
    database = MockDatabase();
    provider = TodosCacheProviderLocal(database: database);
  });

  group('getTodos method', () {
    test('should return todos list', () async {
      when(() => database.query('todos',
              limit: 20, offset: any(named: 'offset'), orderBy: 'id'))
          .thenAnswer(
              (_) async => todosList.todos.map((e) => e.toMap()).toList());
      when(() => database.rawQuery(any())).thenAnswer((_) async => [
            {'count': todosList.total}
          ]);
      final result = await provider.getTodos(0);

      expect(result, todosList);
    });

    test('should throw NoTodosException when count is 0', () {
      when(() => database.rawQuery(any())).thenAnswer((_) async => [
            {'count': 0}
          ]);

      expect(() => provider.getTodos(0), throwsA(isA<NoTodosException>()));
    });
  });

  group('getTodo method', () {
    final todoJson = fixture('todo');
    final todo = TodoModel.fromJson(todoJson);

    test('should return todo', () async {
      when(() => database.query('todos', where: 'id = ?', whereArgs: [todo.id]))
          .thenAnswer((_) async => [todo.toMap()]);

      final result = await provider.getTodo(todo.id);
      expect(result, todo);
    });

    test('should throw NotFoundException when query returns empty', () async {
      when(() => database.query('todos', where: 'id = ?', whereArgs: [todo.id]))
          .thenAnswer((_) async => []);

      expect(
          () => provider.getTodo(todo.id), throwsA(isA<NotFoundException>()));
    });
  });

  group('cacheTodos method', () {
    setUp(() {
      when(() => database.delete('todos', where: null))
          .thenAnswer((_) async => 10);
      when(() => database.insert('todos', any())).thenAnswer((_) async => 1);
      when(() => database.transaction(any())).thenAnswer((_) async => null);
    });
    test('should clear todos table', () async {
      await provider.cacheTodos(todosList);

      verify(() => database.delete('todos', where: null)).called(1);
    });

    test('should call insert as many times as todos', () async {
      await provider.cacheTodos(todosList);
      verify(() => database.insert('todos', any()))
          .called(todosList.todos.length);
    });
  });
}
