import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_test/core/routes.dart';
import 'package:maids_test/core/validators.dart';
import 'package:maids_test/features/todos/presentation/blocs/add_todo_cubit.dart';
import 'package:maids_test/features/todos/presentation/blocs/add_todo_states.dart';
import 'package:maids_test/injection_container.dart';
import 'package:maids_test/shared/widgets/error_dialog.dart';

class AddTodoPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddTodoCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Todo'),
        ),
        body: BlocListener<AddTodoCubit, AddTodoState>(
          listener: (context, state) {
            if (state is AddTodoSuccess) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            } else if (state is AddTodoFailed) {
              showDialog(
                  context: context,
                  builder: (_) => ErrorDialog(message: state.message));
            }
          },
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                TextFormField(
                  controller: controller,
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
                  height: 32,
                ),
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AddTodoCubit>().addTodo(controller.text);
                      }
                    },
                    child: const Text("Add"),
                  );
                }),
                const SizedBox(
                  height: 32,
                ),
                BlocBuilder<AddTodoCubit, AddTodoState>(
                  builder: (context, state) {
                    return Center(
                        child: Visibility(
                            visible: state is AddTodoLoading,
                            child: const CircularProgressIndicator()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
