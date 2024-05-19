import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/data/models/todo_list_model.dart';

abstract class TodosProviderAbstract {
  Future<TodosListModel> getTodos(int skip);

  Future<TodoModel> addTodo(TodoModel todo);
  Future<TodoModel> getTodo(int id);

  Future<void> updateTodo(TodoModel todo);

  Future<void> deleteTodo(TodoModel todo);
}
