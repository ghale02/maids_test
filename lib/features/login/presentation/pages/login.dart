import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_test/core/routes.dart';
import 'package:maids_test/core/validators.dart';
import 'package:maids_test/features/login/presentation/blocs/login_cubit.dart';
import 'package:maids_test/features/login/presentation/blocs/login_states.dart';
import 'package:maids_test/injection_container.dart';
import 'package:maids_test/shared/widgets/error_dialog.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController(),
      passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  LoginPage({super.key}) {
    if (kDebugMode) {
      usernameController.text = "kminchelle";
      passwordController.text = "0lelplR";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => sl<LoginCubit>(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                } else if (state is LoginFailed) {
                  showDialog(
                      context: context,
                      builder: (_) => ErrorDialog(message: state.error));
                }
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Username")),
                      controller: usernameController,
                      validator: requiredField,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Password")),
                      controller: passwordController,
                      obscureText: true,
                      validator: requiredField,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                                usernameController.text,
                                passwordController.text);
                          }
                        },
                        child: const Text("Login"),
                      );
                    }),
                    const SizedBox(
                      height: 32,
                    ),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) => Visibility(
                          visible: state is LoginLoading,
                          child: const CircularProgressIndicator()),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
