import 'package:equatable/equatable.dart';

import 'package:maids_test/features/todos/domain/entities/todos_list_entity.dart';

abstract class TodosListState extends Equatable {
  final TodosListEntity todos;
  final int skip;
  const TodosListState({
    this.todos = const TodosListEntity(todos: [], total: 0),
    this.skip = 0,
  });

  @override
  List<Object?> get props => [todos, skip];

  TodosListState copyWith();
}

class TodosListInitial extends TodosListState {
  @override
  TodosListInitial copyWith() {
    return TodosListInitial();
  }
}

class TodosListLoading extends TodosListState {
  final bool loadingMore;

  const TodosListLoading({
    required this.loadingMore,
    super.todos,
    super.skip,
  });
  @override
  TodosListState copyWith() {
    throw UnimplementedError();
  }

  @override
  // TODO: implement props
  List<Object?> get props => super.props + [loadingMore];
}

class TodosListLoaded extends TodosListState {
  const TodosListLoaded({required super.todos, required super.skip});

  @override
  TodosListLoaded copyWith() {
    return TodosListLoaded(
      todos: todos,
      skip: skip,
    );
  }
}
