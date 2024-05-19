import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/shared/providers/connection_checker_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker checker;
  late ConnectionCheckerImpl provider;
  setUp(() {
    checker = MockInternetConnectionChecker();
    provider = ConnectionCheckerImpl(checker);
  });

  test('when checker return true', () async {
    when(() => checker.hasConnection).thenAnswer((_) async => true);
    final res = await provider.isConnected();
    verify(() => checker.hasConnection);
    expect(res, true);
  });

  test('when checker return false', () async {
    when(() => checker.hasConnection).thenAnswer((_) async => false);
    final res = await provider.isConnected();
    expect(res, false);
  });
}
