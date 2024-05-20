import 'package:bloc/bloc.dart';
import 'package:maids_test/features/todos/domain/entities/todo_entity.dart';

import 'package:maids_test/features/todos/domain/use_cases/delete_todo_usecase.dart';
import 'package:maids_test/features/todos/domain/use_cases/get_todo_usecase.dart';
import 'package:maids_test/features/todos/domain/use_cases/update_todo_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/todo_states.dart';

class TodoCubit extends Cubit<TodoState> {
  final GetTodoUseCase getTodoUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;

  TodoCubit({
    required this.getTodoUsecase,
    required this.updateTodoUsecase,
    required this.deleteTodoUsecase,
  }) : super(TodoInitial());

  Future<void> getTodo(int id) async {
    emit(TodoLoading());
    final result = await getTodoUsecase(GetTodoParams(id: id));
    result.fold(
      (failure) => emit(TodoInitial()),
      (todo) => emit(TodoLoaded(todo: todo)),
    );
  }

  Future<void> updateTodo(TodoEntity todo) async {
    if (state is! TodoSubmitting) {
      final oldTodo = (state as TodoLoaded).todo;
      emit(TodoSubmitting(todo: oldTodo));
      final result = await updateTodoUsecase(UpdateTodoParams(todo: todo));
      result.fold(
        (failure) {
          emit(TodoError(todo: oldTodo, message: failure.message));
          emit(TodoLoaded(todo: oldTodo));
        },
        (_) => emit(TodoLoaded(todo: todo)),
      );
    }
  }

  Future<void> deleteTodo(TodoEntity todo) async {
    if (state is! TodoSubmitting) {
      final oldTodo = (state as TodoLoaded).todo;
      emit(TodoSubmitting(todo: oldTodo));
      final result = await deleteTodoUsecase(DeleteTodoParams(todo: todo));
      result.fold(
        (failure) {
          emit(TodoError(todo: oldTodo, message: failure.message));
          emit(TodoLoaded(todo: oldTodo));
        },
        (_) => emit(TodoDeleted()),
      );
    }
  }
}
