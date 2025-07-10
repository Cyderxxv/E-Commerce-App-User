import '../models/user_model.dart';

class AuthState{
  const AuthState();
}

class AuthInitial extends AuthState {}

class RegisterState extends AuthState {
  final bool success;
  final String? message;
  final UserModel? userModel;

  const RegisterState({
    required this.success,
    this.message,
    this.userModel,
  });
}

class LoginState extends AuthState {
  final bool success;
  final String? message;
  final UserModel? userModel;

  const LoginState({
    required this.success,
    this.message,
    this.userModel,
  });
}

class ForgotPasswordState extends AuthState {
  final bool success;
  final String? message;

  const ForgotPasswordState({
    required this.success,
    required this.message,
  });
}

class LogoutState extends AuthState {
  final bool success;
  final String? message;

  const LogoutState({
    required this.success,
    this.message,
  });
}