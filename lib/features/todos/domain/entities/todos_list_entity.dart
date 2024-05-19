import 'package:equatable/equatable.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';

class TodosListEntity extends Equatable {
  final List<TodoEntity> todos;
  final int total;

  const TodosListEntity({
    required this.todos,
    required this.total,
  });

  @override
  List<Object> get props => [todos, total];

  TodosListEntity merge(TodosListEntity other) => TodosListEntity(
      todos: todos + other.todos, total: total == 0 ? other.total : total);
}
