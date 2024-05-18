import 'package:bloc/bloc.dart';
import 'package:maids_test/features/login/domain/use_cases/login_usecase.dart';
import 'package:maids_test/features/login/presentation/blocs/login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());

    final res =
        await loginUseCase(LoginParams(username: username, password: password));

    res.fold((l) => emit(LoginFailed(error: l.message)),
        (r) => emit(LoginSuccess()));
  }
}
