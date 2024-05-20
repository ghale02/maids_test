import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:maids_test/features/todos/data/models/todo_db_model.dart';

//we need this model because sqlite use integer for booleans
class TodosDbListModel extends Equatable {
  final List<TodoDbModel> todos;
  final int total;

  const TodosDbListModel({required this.todos, required this.total});

  factory TodosDbListModel.fromMap(Map<String, dynamic> map) {
    return TodosDbListModel(
      todos: TodoDbModel.fromJsonList(map['todos']),
      total: map['total'],
    );
  }

  factory TodosDbListModel.fromJson(String str) =>
      TodosDbListModel.fromMap(jsonDecode(str));

  @override
  List<Object?> get props => [todos, total];
}
