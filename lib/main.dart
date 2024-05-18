import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maids_test/core/routes.dart';
import 'injection_container.dart' as ic;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterSecureStorage().deleteAll();
  ic.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.generate,
      initialRoute: AppRoutes.autoLogin,
    );
  }
}
