import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/todos/data/models/todo_db_list_model.dart';
import 'package:maids_test/features/todos/data/models/todo_db_model.dart';
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_abstract.dart';
import 'package:sqflite/sqflite.dart';

class TodosCacheProviderLocal extends TodosCacheProviderAbstract {
  Database database;
  TodosCacheProviderLocal({
    required this.database,
  });

  @override
  Future<TodoDbModel> getTodo(int id) async {
    //query by id
    final todosDb =
        await database.query('todos', where: 'id = ?', whereArgs: [id]);
    if (todosDb.isNotEmpty) {
      return TodoDbModel.fromMap(todosDb.first);
    } else {
      throw NotFoundException();
    }
  }

  @override
  Future<TodosDbListModel> getTodos(int skip) async {
    //get todos count
    final int count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM todos'))!;

    if (count == 0) {
      throw NoTodosException();
    }
    //query with limit 20 for pagination
    final todosDb =
        await database.query('todos', limit: 20, offset: skip, orderBy: 'id');
    final todosList = todosDb.map((e) => TodoDbModel.fromMap(e)).toList();

    return TodosDbListModel(todos: todosList, total: count);
  }

  @override
  Future<void> cacheTodos(TodosDbListModel todos) async {
    //clear old cached todos
    await database.delete('todos');
    for (var todo in todos.todos) {
      await database.insert('todos', todo.toMap());
    }
  }
}
