import 'package:maids_test/features/todos/data/models/todo_db_model.dart';
import 'package:maids_test/features/todos/data/models/todo_model.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';

extension TodoModelToEntityMapper on TodoModel {
  TodoEntity toEntity() => TodoEntity(
        id: id,
        todo: todo,
        completed: completed,
        userId: userId,
      );

  TodoDbModel toDbModel() => TodoDbModel(
        id: id,
        todo: todo,
        completed: completed,
        userId: userId,
      );
}

extension TodoDbModelToEntityMapper on TodoDbModel {
  TodoEntity toEntity() => TodoEntity(
        id: id,
        todo: todo,
        completed: completed,
        userId: userId,
      );
}

extension TodoEntityToModelMapper on TodoEntity {
  TodoModel toModel() => TodoModel(
        id: id,
        todo: todo,
        completed: completed,
        userId: userId,
      );
}
