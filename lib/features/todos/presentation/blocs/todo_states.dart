import 'package:equatable/equatable.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final TodoEntity todo;
  TodoLoaded({required this.todo});

  @override
  List<Object> get props => [todo];
}

class TodoSubmitting extends TodoLoaded {
  TodoSubmitting({required super.todo});
}

class TodoError extends TodoLoaded {
  final String message;

  TodoError({required super.todo, required this.message});

  @override
  List<Object> get props => [message];
}

class TodoDeleted extends TodoState {}
