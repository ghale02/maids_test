import 'package:maids_test/core/debug.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/todos/data/models/todo.dart';
import 'package:maids_test/features/todos/data/models/todo_list.dart';
import 'package:maids_test/features/todos/data/providers/todos_provider_abstract.dart';
import 'package:http/http.dart' as http;

class TodosProviderApi extends TodosProviderAbstract {
  final http.Client client;

  TodosProviderApi({required this.client});

  @override
  Future<TodoModel> addTodo(TodoModel todo) async {
    http.Response response;
    try {
      response = await client.post(Uri.parse('https://dummyjson.com/todos/add'),
          headers: {'Content-Type': 'application/json'}, body: todo.toJson());
    } catch (e) {
      debugPrint(e);
      throw UnknownException();
    }

    if (response.statusCode == 200) {
      final todo = TodoModel.fromJson(response.body);

      return todo;
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    http.Response response;
    try {
      response = await client
          .delete(Uri.parse('https://dummyjson.com/todos/${todo.id}'));
    } catch (e) {
      debugPrint(e);
      throw UnknownException();
    }

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<TodosListModel> getTodos(int skip) async {
    http.Response response;
    try {
      response = await client
          .get(Uri.parse('https://dummyjson.com/todos?skip=$skip&limit=20'));
    } catch (e) {
      debugPrint(e);
      throw UnknownException();
    }

    if (response.statusCode == 200) {
      final todos = TodosListModel.fromJson(response.body);

      return todos;
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    http.Response response;
    try {
      response = await client.put(
          Uri.parse('https://dummyjson.com/todos/${todo.id}'),
          headers: {'Content-Type': 'application/json'},
          body: todo.toJson());
    } catch (e) {
      debugPrint(e);
      throw UnknownException();
    }

    if (response.statusCode == 200) {
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

//https://dummyjson.com/todos/1
  @override
  Future<TodoModel> getTodo(int id) async {
    http.Response response;
    try {
      response = await client.get(Uri.parse('https://dummyjson.com/todos/$id'));
    } catch (e) {
      debugPrint(e);
      throw UnknownException();
    }

    if (response.statusCode == 200) {
      final todo = TodoModel.fromJson(response.body);

      return todo;
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }
}
