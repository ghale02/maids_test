import 'package:bloc/bloc.dart';

import 'package:maids_test/features/todos/domain/use_cases/add_todo_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/add_todo_states.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final AddTodoUsecase usecase;
  AddTodoCubit(this.usecase) : super(AddTodoInitial());

  Future<void> addTodo(String todo) async {
    if (state is! AddTodoLoading) {
      emit(AddTodoLoading());
      final result = await usecase(AddTodoParams(todo: todo));
      result.fold((l) => emit(AddTodoFailed(message: l.message)),
          (r) => emit(AddTodoSuccess()));
    }
  }
}
