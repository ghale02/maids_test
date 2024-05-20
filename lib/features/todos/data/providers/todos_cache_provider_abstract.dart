import 'package:maids_test/features/todos/data/models/todo_db_list_model.dart';
import 'package:maids_test/features/todos/data/models/todo_db_model.dart';

abstract class TodosCacheProviderAbstract {
  Future<TodosDbListModel> getTodos(int skip);
  Future<TodoDbModel> getTodo(int id);
  Future<void> cacheTodos(TodosDbListModel todos);
}
