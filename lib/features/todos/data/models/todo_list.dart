import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:maids_test/features/todos/data/models/todo.dart';

class TodosListModel extends Equatable {
  final List<TodoModel> todos;
  final int total;

  const TodosListModel({required this.todos, required this.total});

  factory TodosListModel.fromMap(Map<String, dynamic> map) {
    return TodosListModel(
      todos: TodoModel.fromJsonList(map['todos']),
      total: map['total'],
    );
  }

  factory TodosListModel.fromJson(String str) =>
      TodosListModel.fromMap(jsonDecode(str));

  @override
  List<Object?> get props => [todos, total];
}
