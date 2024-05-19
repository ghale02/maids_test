import 'package:maids_test/features/todos/data/models/todo.dart';
import 'package:maids_test/features/todos/data/models/todo_list.dart';

abstract class TodosProviderAbstract {
  Future<TodosListModel> getTodos(int skip);

  Future<TodoModel> addTodo(TodoModel todo);
  Future<TodoModel> getTodo(int id);

  Future<void> updateTodo(TodoModel todo);

  Future<void> deleteTodo(TodoModel todo);
}
