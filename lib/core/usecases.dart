import 'package:dartz/dartz.dart';
import 'package:maids_test/core/failure.dart';

abstract class UseCase<In, Out> {
  Future<Either<Failure, Out>> call(In input);
}

class NoParams {}
