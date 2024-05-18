import 'package:maids_test/features/login/data/models/user_model.dart';

abstract class AuthManagerAbstract {
  Future<void> setUser(UserModel user);

  Future<UserModel> getUser();

  Future<void> logout();
}
