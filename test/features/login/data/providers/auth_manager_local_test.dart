import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/login/data/models/user_model.dart';
import 'package:maids_test/features/login/data/providers/auth_manager_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage storage;
  late AuthManagerLocal provider;

  setUp(() {
    storage = MockFlutterSecureStorage();
    provider = AuthManagerLocal(storage: storage);
  });

  test('logout', () async {
    when(() => storage.delete(key: 'user')).thenAnswer((_) async => null);
    await provider.logout();
    verify(() => storage.delete(key: 'user')).called(1);
  });

  test('getUser throw NoUserFound', () async {
    when(() => storage.read(key: 'user')).thenAnswer((_) async => null);
    expect(() => provider.getUser(), throwsA(isA<NoUserFound>()));
  });
  test('getUser storage return Data has been reset', () {
    when(() => storage.read(key: 'user'))
        .thenAnswer((_) async => 'Data has been reset');
    expect(() => provider.getUser(), throwsA(isA<NoUserFound>()));
  });

  test('getUser return json data', () async {
    final json = fixture('user');
    final UserModel model = UserModel.fromJson(json);
    when(() => storage.read(key: 'user')).thenAnswer((_) async => json);
    final res = await provider.getUser();
    expect(res, model);
  });
// TODO: setUser Test
  // test('setUser', () async {
  //   final json = fixture('user');
  //   when(() => storage.write(key: 'user', value: json))
  //       .thenAnswer((_) => Future<void>.value());

  //   await provider.setUser(UserModel.fromJson(json));
  //   verify(() => storage.write(key: 'user', value: json)).called(1);
  // });
}
