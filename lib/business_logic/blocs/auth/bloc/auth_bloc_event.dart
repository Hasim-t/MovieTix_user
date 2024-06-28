part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class CheckLoginStatusEvent extends AuthBlocEvent {}

class LoingEvent extends AuthBlocEvent {
  final String email;
  final String password;

  LoingEvent({required this.email, required this.password});
}

//singup event

class SingupEvnet extends AuthBlocEvent {
  final UserModel user;

  SingupEvnet({required this.user});
}

// 
 class LogoutEvent extends AuthBlocEvent{
  
 }
 class GoogleSignInEvent extends AuthBlocEvent {}