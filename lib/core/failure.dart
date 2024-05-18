import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;

  Failure({required this.message});

  @override
  String toString() => message;

  @override
  List<Object> get props => [message];
}

class AuthLoginFailure extends Failure {
  AuthLoginFailure() : super(message: 'Login Failed');
}
