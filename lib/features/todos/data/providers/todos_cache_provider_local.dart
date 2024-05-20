import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/todos/data/providers/todos_cache_provider_abstract.dart';
import 'package:sqflite/sqflite.dart';

import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/data/models/todo_list_model.dart';

class TodosCacheProviderLocal extends TodosCacheProviderAbstract {
  Database database;
  TodosCacheProviderLocal({
    required this.database,
  });

  @override
  Future<TodoModel> getTodo(int id) async {
    final todosDb =
        await database.query('todos', where: 'id = ?', whereArgs: [id]);
    if (todosDb.isNotEmpty) {
      return TodoModel.fromMap(todosDb.first);
    } else {
      throw NotFoundException();
    }
  }

  @override
  Future<TodosListModel> getTodos(int skip) async {
    final int count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM todos'))!;

    if (count == 0) {
      throw NoTodosException();
    }
    final todosDb =
        await database.query('todos', limit: 20, offset: skip, orderBy: 'id');
    final todosList = todosDb.map((e) => TodoDbModel.fromMap(e)).toList();

    return TodosListModel(todos: todosList, total: count);
  }

  @override
  Future<void> cacheTodos(TodosListModel todos) async {
    await database.delete('todos');
    for (var todo in todos.todos) {
      await database.insert('todos', todo.toMap());
    }
  }
}
