import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const TodoEntity({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, todo, completed, userId];
}
