import '../models/input_forgot_password_model.dart';
import '../models/input_login_model.dart';
import '../models/input_register_model.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class RegisterEvent extends AuthEvent {
  final InputRegisterModel data;

  const RegisterEvent({required this.data});
}

final class LoginEvent extends AuthEvent {
  final InputLoginModel data;

  const LoginEvent({required this.data});
}

final class ForgotPasswordEvent extends AuthEvent {
  final ForgotPasswordModel data;

  const ForgotPasswordEvent({required this.data});
}

final class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}