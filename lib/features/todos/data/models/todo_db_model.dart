import 'dart:convert';

import 'package:equatable/equatable.dart';

//we need this model because sqflite use integer for booleanss
class TodoDbModel extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const TodoDbModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodoDbModel.fromJson(String str) =>
      TodoDbModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodoDbModel.fromMap(Map<String, dynamic> json) => TodoDbModel(
        id: json["id"],
        todo: json["todo"],
        completed: json["completed"] == 1 || json["completed"] == true,
        userId: json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "todo": todo,
        "completed": completed,
        "userId": userId,
      };
  // generate from json list
  static List<TodoDbModel> fromJsonList(List list) {
    return list.map((item) => TodoDbModel.fromMap(item)).toList();
  }

  @override
  List<Object?> get props => [id];
}
