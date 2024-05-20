import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/login/data/models/user_model.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_abstract.dart';

class AuthManagerLocal implements AuthManagerAbstract {
  FlutterSecureStorage storage;
  AuthManagerLocal({required this.storage});

  @override
  Future<UserModel> getUser() async {
    try {
      String? usrJ = await storage.read(key: 'user');
      //* secure storage may be cleared then will return 'Data has been reset'
      if (usrJ == null || usrJ == 'Data has been reset') {
        throw NoUserFound();
      } else {
        return UserModel.fromJson(usrJ);
      }
    } catch (e) {
      throw NoUserFound();
    }
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: 'user');
  }

  @override
  Future<void> setUser(UserModel user) async {
    storage.write(key: 'user', value: user.toJson());
  }
}
