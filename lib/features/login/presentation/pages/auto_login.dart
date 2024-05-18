import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_test/core/routes.dart';
import 'package:maids_test/features/login/presentation/blocs/auto_login_states.dart';
import 'package:maids_test/injection_container.dart';
import 'package:maids_test/features/login/presentation/blocs/auto_login_cubit.dart';
import 'package:maids_test/shared/widgets/loading_error.dart';

class AutoLoginPage extends StatelessWidget {
  const AutoLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          final cubit = sl<AutoLoginCubit>();
          cubit.autoLogin();
          return cubit;
        },
        child: BlocConsumer<AutoLoginCubit, AutoLoginState>(
          listener: (context, state) {
            if (state is AutoLoginSuccess) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            } else if (state is AutoLoginNotCompleted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            }
          },
          builder: (context, state) {
            if (state is AutoLoginInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AutoLoginFailed) {
              return LoadingError(
                  retryCallback: () =>
                      context.read<AutoLoginCubit>().autoLogin());
            }
            return Container();
          },
        ),
      ),
    );
  }
}
