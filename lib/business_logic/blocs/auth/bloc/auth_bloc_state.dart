part of 'auth_bloc_bloc.dart';


sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

class AuthLoading extends AuthBlocState {}

class Authenticated extends AuthBlocState {
  User? user;

  Authenticated(this.user);
}

class UnAutheticated extends AuthBlocState {}

class AutheticatedError extends AuthBlocState {
  final String msg;
  AutheticatedError({required this.msg});
}
