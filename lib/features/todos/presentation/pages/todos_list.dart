import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_test/features/todos/domain/entities/todos_list_entity.dart';
import 'package:maids_test/features/todos/presentation/blocs/todos_list_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/todos_list_states.dart';
import 'package:maids_test/injection_container.dart';
import 'package:maids_test/shared/widgets/loading_error.dart';

class TodosListPage extends StatelessWidget {
  const TodosListPage({super.key});

  ScrollController genController(TodosListCubit cubit) {
    final controller = ScrollController();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        cubit.load();
      }
    });
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos List'),
      ),
      body: BlocProvider(
        create: (context) {
          final cubit = sl<TodosListCubit>();
          cubit.load();
          return cubit;
        },
        child: BlocBuilder<TodosListCubit, TodosListState>(
          buildWhen: (previous, current) {
            return (previous is TodosListInitial &&
                    current is TodosListLoading) ||
                (previous is TodosListLoading && current is TodosListInitial) ||
                (previous is TodosListLoading &&
                    !previous.loadingMore &&
                    current is TodosListLoaded);
          },
          builder: (context, state) {
            if (state is TodosListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TodosListInitial) {
              return LoadingError(
                retryCallback: () => context.read<TodosListCubit>().load(),
              );
            }

            return ListView(
              controller: genController(context.read<TodosListCubit>()),
              children: [
                BlocSelector<TodosListCubit, TodosListState, TodosListEntity>(
                  selector: (state) {
                    return state.todos;
                  },
                  builder: (context, state) {
                    return Column(
                      children: state.todos
                          .map(
                            (e) => ListTile(
                              title: Text(
                                e.todo,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<TodosListCubit, TodosListState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state is TodosListLoading && state.loadingMore,
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
