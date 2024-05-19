import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const TodoModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodoModel.fromJson(String str) => TodoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        todo: json["todo"],
        completed: json["completed"],
        userId: json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "todo": todo,
        "completed": completed,
        "userId": userId,
      };
  // generate from json list
  static List<TodoModel> fromJsonList(List list) {
    return list.map((item) => TodoModel.fromMap(item)).toList();
  }

  @override
  List<Object?> get props => [id];
}
