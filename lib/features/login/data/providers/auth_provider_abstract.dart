import 'package:maids_test/features/login/data/models/user_model.dart';

abstract class AuthProviderAbstract {
  Future<UserModel> login(String username, String password);
  Future<UserModel> refreshToken(String token);
}
