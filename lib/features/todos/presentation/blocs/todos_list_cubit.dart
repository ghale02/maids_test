import 'package:bloc/bloc.dart';

import 'package:maids_test/features/todos/domain/use_cases/get_todos_usecase.dart';
import 'package:maids_test/features/todos/presentation/blocs/todos_list_states.dart';

class TodosListCubit extends Cubit<TodosListState> {
  final GetTodosUseCase useCase;
  TodosListCubit(this.useCase) : super(TodosListInitial());

  Future<void> load() async {
    if (state.skip == state.todos.total && state is! TodosListInitial) {
      return;
    }
    final oldState = state;

    emit(TodosListLoading());
    final result = await useCase(GetTodosParams(skip: oldState.skip));

    result.fold(
        (l) => emit(oldState.copyWith()),
        (r) => emit(TodosListLoaded(
            todos: oldState.todos.merge(r), skip: oldState.skip + 20)));
  }
}
