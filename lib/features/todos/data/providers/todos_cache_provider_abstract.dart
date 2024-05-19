import 'package:maids_test/features/todos/data/models/todo.dart';
import 'package:maids_test/features/todos/data/models/todo_list.dart';

abstract class TodosCacheProviderAbstract {
  Future<TodosListModel> getTodos(int skip);
  Future<TodoModel> getTodo(int id);
  Future<void> cacheTodos(TodosListModel todos);
}
