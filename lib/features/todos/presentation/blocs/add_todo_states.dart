import 'package:equatable/equatable.dart';

abstract class AddTodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTodoInitial extends AddTodoState {}

class AddTodoLoading extends AddTodoState {}

class AddTodoSuccess extends AddTodoState {}

class AddTodoFailed extends AddTodoState {
  final String message;

  AddTodoFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
