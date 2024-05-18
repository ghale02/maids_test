import 'package:flutter_test/flutter_test.dart';
import 'package:maids_test/core/validators.dart';

void main() {
  group('isNotEmpty validator', () {
    test('should return null if value is not empty', () {
      final result = requiredField('test');
      expect(result, null);
    });
    test('should return error if value is empty', () {
      final result = requiredField('');
      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });
    test('should return error if value is null', () {
      final result = requiredField(null);
      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });
  });
}
