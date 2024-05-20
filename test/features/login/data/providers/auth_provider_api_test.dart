import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/login/data/models/user_model.dart';
import 'package:maids_test/features/login/data/providers/auth_provider_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixture.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AuthProviderApi api;
  late MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    api = AuthProviderApi(client: httpClient);
    registerFallbackValue(Uri());
  });
  group('login method', () {
    test('should throw ServerException on 500', () {
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 500));
      expect(() => api.login('', ''), throwsA(isA<ServerException>()));
    });
    test('should throw WrongCredentials on 400', () {
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 400));
      expect(() => api.login('', ''), throwsA(isA<WrongCredentials>()));
    });
    test('should throw UnknownException on other code', () {
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 403));
      expect(() => api.login('', ''), throwsA(isA<UnknownException>()));
    });
    test('should throw UnknownException on http throw Exception', () {
      when(() => httpClient.post(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenThrow(Exception());
      expect(() => api.login('', ''), throwsA(isA<UnknownException>()));
    });

    test('should return UserModel when code is 200', () async {
      const username = 'username', password = '123456789';
      final String json = fixture('user');
      final UserModel userModel = UserModel.fromJson(json);
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(json, 200));
      final UserModel response = await api.login(username, password);

      expect(userModel, response);
    });
  });
}
