import 'package:bloc/bloc.dart';
import 'package:maids_test/core/failure.dart';
import 'package:maids_test/core/usecases.dart';
import 'package:maids_test/features/login/domain/use_cases/auto_login_usecase.dart';
import 'package:maids_test/features/login/presentation/blocs/auto_login_states.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  final AutoLoginUseCase useCase;
  AutoLoginCubit({required this.useCase}) : super(AutoLoginInitial());

  Future<void> autoLogin() async {
    emit(AutoLoginInitial());
    final res = await useCase(NoParams());
    res.fold((l) {
      if (l is AutoLoginFailure) {
        emit(AutoLoginNotCompleted());
      } else {
        emit(AutoLoginFailed(error: l.message));
      }
    }, (r) => emit(AutoLoginSuccess()));
  }
}
