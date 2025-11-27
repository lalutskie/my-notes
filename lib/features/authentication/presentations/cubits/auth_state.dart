import '../../domain/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel? userModel;

  Authenticated(this.userModel);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError(this.errorMessage);
}