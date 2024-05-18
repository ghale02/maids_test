import 'package:equatable/equatable.dart';

abstract class AutoLoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AutoLoginInitial extends AutoLoginState {}

class AutoLoginSuccess extends AutoLoginState {}

class AutoLoginFailed extends AutoLoginState {
  final String error;
  AutoLoginFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class AutoLoginNotCompleted extends AutoLoginState {}
