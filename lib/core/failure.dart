import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;

  Failure({required this.message});

  @override
  String toString() => message;

  @override
  List<Object> get props => [message];
}

class AutoLoginFailure extends Failure {
  AutoLoginFailure() : super(message: 'Login Failed');
}
