import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_test/core/routes.dart';
import 'package:maids_test/core/validators.dart';
import 'package:maids_test/features/todos/presentation/blocs/todo_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/todo_states.dart';
import 'package:maids_test/injection_container.dart';
import 'package:maids_test/shared/widgets/error_dialog.dart';
import 'package:maids_test/shared/widgets/loading_error.dart';

class TodoPageArgs {
  final int id;

  TodoPageArgs({required this.id});
}

class TodoPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TodoPageArgs args;
  TodoPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<TodoCubit>();
        cubit.getTodo(args.id);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Todo'),
        ),
        body: BlocListener<TodoCubit, TodoState>(
          listener: (context, state) {
            if (state is TodoDeleted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            } else if (state is TodoError) {
              showDialog(
                  context: context,
                  builder: (_) => ErrorDialog(message: state.message));
            }
          },
          child: BlocBuilder<TodoCubit, TodoState>(
            buildWhen: (previous, current) =>
                (previous is TodoLoading && current is TodoLoaded) ||
                (previous is TodoInitial && current is TodoLoading) ||
                (previous is TodoLoading && current is TodoInitial),
            builder: (context, state) {
              if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TodoInitial) {
                return LoadingError(
                    retryCallback: () =>
                        context.read<TodoCubit>().getTodo(args.id));
              }
              if (state is TodoLoaded) {
                return Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(32),
                    children: [
                      TextFormField(
                        controller: controller..text = state.todo.todo,
                        validator: requiredField,
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 3,
                        maxLength: 150,
                        decoration: const InputDecoration(
                          hintText: 'Todo description',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      BlocSelector<TodoCubit, TodoState, bool>(
                        selector: (state) {
                          return (state as TodoLoaded).todo.completed;
                        },
                        builder: (context, state) {
                          return CheckboxListTile(
                            value: state,
                            onChanged: (v) =>
                                context.read<TodoCubit>().setCompleted(v!),
                            title: const Text("Completed"),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<TodoCubit>()
                                  .updateTodo(controller.text);
                            }
                          },
                          child: const Text("Save"),
                        );
                      }),
                      const SizedBox(
                        height: 32,
                      ),
                      Builder(builder: (context) {
                        return TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.error)),
                            onPressed: () {
                              context.read<TodoCubit>().deleteTodo();
                            },
                            child: const Text('Delete'));
                      }),
                      const SizedBox(
                        height: 32,
                      ),
                      BlocBuilder<TodoCubit, TodoState>(
                        buildWhen: (previous, current) =>
                            previous is TodoSubmitting ||
                            current is TodoSubmitting,
                        builder: (context, state) {
                          return Center(
                              child: Visibility(
                                  visible: state is TodoSubmitting,
                                  child: const CircularProgressIndicator()));
                        },
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
