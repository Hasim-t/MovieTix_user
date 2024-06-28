part of 'google_auth_bloc.dart';

@immutable
abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthenticated extends GoogleAuthState {
  final User user;

  GoogleAuthenticated(this.user);
}

class GoogleAuthErrorState extends GoogleAuthState {
  final String errorMessage;

  GoogleAuthErrorState(this.errorMessage);
}
