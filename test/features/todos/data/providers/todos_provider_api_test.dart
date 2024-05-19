import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/todos/data/models/todo.dart';

import 'package:maids_test/features/todos/data/models/todo_list.dart';
import 'package:maids_test/features/todos/data/providers/todos_provider_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixture.dart';

//mock http client
class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient client;
  late TodosProviderApi provider;
  //get json from fixtures
  final json = fixture('todo');
  final todo = TodoModel.fromJson(json);
  setUp(() {
    client = MockClient();
    provider = TodosProviderApi(client: client);
    registerFallbackValue(Uri());
  });

  group('getTodos Method', () {
    test('should throw ServerException on 500 code', () {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('', 500),
      );

      expect(() => provider.getTodos(0), throwsA(isA<ServerException>()));
    });

    test('should throw UnknownException on other codes', () {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('', 404),
      );

      expect(() => provider.getTodos(0), throwsA(isA<UnknownException>()));
    });

    test('should throw UnknownException on http error', () {
      when(() => client.get(any())).thenThrow(Exception());

      expect(() => provider.getTodos(0), throwsA(isA<UnknownException>()));
    });

    test('should return TodosListModel on 200 code', () async {
      //get json from fixtures
      final json = fixture('todos_list');
      final todos = TodosListModel.fromJson(json);
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(json, 200),
      );
      final result = await provider.getTodos(0);

      expect(result, todos);
    });
  });

  group('getTodo method', () {
    test('should throw ServerException on 500 code', () {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('', 500),
      );

      expect(() => provider.getTodo(1), throwsA(isA<ServerException>()));
    });

    test('should throw UnknownException on other codes', () {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('', 400),
      );

      expect(() => provider.getTodo(1), throwsA(isA<UnknownException>()));
    });
    test('should throw NotFoundException on 404 code', () {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('', 404),
      );

      expect(() => provider.getTodo(1), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException on http error', () {
      when(() => client.get(any())).thenThrow(Exception());

      expect(() => provider.getTodo(1), throwsA(isA<UnknownException>()));
    });

    test('should return Todo on 200 code', () async {
      //get json from fixtures
      final json = fixture('todo');
      final todos = TodoModel.fromJson(json);
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(json, 200),
      );
      final result = await provider.getTodo(1);

      expect(result, todos);
    });
  });
  group('addTodo method', () {
    test('should throw ServerException on 500 code', () {
      when(() => client.post(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response('', 500),
      );

      expect(() => provider.addTodo(todo), throwsA(isA<ServerException>()));
    });

    test('should throw UnknownException on other codes', () {
      when(() => client.post(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response('', 400),
      );

      expect(() => provider.addTodo(todo), throwsA(isA<UnknownException>()));
    });

    test('should throw UnknownException on http error', () {
      when(() => client.post(any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'))).thenThrow(Exception());

      expect(() => provider.addTodo(todo), throwsA(isA<UnknownException>()));
    });

    test('should return Todo on 200 code', () async {
      when(() => client.post(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(json, 200),
      );
      final result = await provider.addTodo(todo);

      expect(result, todo);
    });
  });
  group('updateTodo method', () {
    test('should throw ServerException on 500', () {
      when(() => client.put(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response('', 500),
      );

      expect(() => provider.updateTodo(todo), throwsA(isA<ServerException>()));
    });

    test('should throw UnknownException on other codes', () {
      when(() => client.put(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response('', 400),
      );

      expect(() => provider.updateTodo(todo), throwsA(isA<UnknownException>()));
    });
    test('should throw NotFoundException on 404 code', () {
      when(() => client.put(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response('', 404),
      );

      expect(
          () => provider.updateTodo(todo), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException on http error', () {
      when(() => client.put(any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'))).thenThrow(Exception());

      expect(() => provider.updateTodo(todo), throwsA(isA<UnknownException>()));
    });

    test('should complete without throwing exceptions on 200 code', () async {
      when(() => client.put(any(),
          body: any(named: 'body'), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(json, 200),
      );
      await provider.updateTodo(todo);
    });
  });

  group('deleteTodo method', () {
    test('should throw ServerException on 500', () {
      when(() => client.delete(any())).thenAnswer(
        (_) async => http.Response('', 500),
      );

      expect(() => provider.deleteTodo(todo), throwsA(isA<ServerException>()));
    });
    test('should throw UnknownException on other codes', () {
      when(() => client.delete(any())).thenAnswer(
        (_) async => http.Response('', 400),
      );

      expect(() => provider.deleteTodo(todo), throwsA(isA<UnknownException>()));
    });

    test('should throw NotFoundException on 404 code', () {
      when(() => client.delete(any())).thenAnswer(
        (_) async => http.Response('', 404),
      );

      expect(
          () => provider.deleteTodo(todo), throwsA(isA<NotFoundException>()));
    });

    test('should throw UnknownException on http error', () {
      when(() => client.delete(any())).thenThrow(Exception());

      expect(() => provider.deleteTodo(todo), throwsA(isA<UnknownException>()));
    });

    test('should complete without throwing exceptions on 200 code', () async {
      when(() => client.delete(any())).thenAnswer(
        (_) async => http.Response('', 200),
      );
      await provider.deleteTodo(todo);
    });
  });
}
