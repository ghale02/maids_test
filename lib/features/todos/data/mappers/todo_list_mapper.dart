import 'package:maids_test/features/todos/data/mappers/todo_mappers.dart';
import 'package:maids_test/features/todos/data/models/todo_list_model.dart';
import 'package:maids_test/features/todos/domain/entities/todos_list_entity.dart';

extension TodosListModelToEntityMapper on TodosListModel {
  TodosListEntity toEntity() => TodosListEntity(
        todos: todos.map((e) => e.toEntity()).toList(),
        total: total,
      );
}

extension TodosListEntityToModelMapper on TodosListEntity {
  TodosListModel toModel() => TodosListModel(
        todos: todos.map((e) => e.toModel()).toList(),
        total: total,
      );
}
