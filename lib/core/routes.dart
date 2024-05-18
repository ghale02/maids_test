import 'package:flutter/material.dart';
import 'package:maids_test/features/login/presentation/pages/auto_login.dart';
import 'package:maids_test/features/login/presentation/pages/login.dart';
// show RouteSettings, MaterialPageRoute, Route;

class AppRoutes {
  static const autoLogin = '/';
  static const login = '/login';
  static const home = '/home';

  static Route? generate(RouteSettings settings) {
    switch (settings.name) {
      case autoLogin:
        return MaterialPageRoute(builder: (context) => const AutoLoginPage());
      case login:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case home:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('Home'),
                  ),
                ));
    }
    return null;
  }
}
