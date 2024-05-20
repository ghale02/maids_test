import 'package:maids_test/shared/providers/connection_checker_abstract.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionCheckerImpl extends ConnectionCheckerAbstract {
  final InternetConnectionChecker checker;

  ConnectionCheckerImpl(this.checker);
  @override
  Future<bool> get isConnected async => false;
}
