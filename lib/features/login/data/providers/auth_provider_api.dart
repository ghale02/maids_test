import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maids_test/core/debug.dart';
import 'package:maids_test/core/exceptions.dart';
import 'package:maids_test/features/login/data/models/user_model.dart';

import 'auth_provider_abstract.dart';

class AuthProviderApi implements AuthProviderAbstract {
  http.Client client;
  AuthProviderApi({
    required this.client,
  });
  @override
  // Asynchronously logs in a user with the provided username and password.
  Future<UserModel> login(String username, String password) async {
    http.Response response;
    try {
      // Sends a POST request to the login endpoint with the provided username and password.
      response = await client.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
    } catch (e) {
      debugPrint(e);
      throw UnknownException();
    }
    // Parses the response body and returns a UserModel if the response is successful
    // otherwise throws an exception.
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else if (response.statusCode == 400) {
      throw WrongCredentials();
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else {
      throw UnknownException();
    }
  }
}
