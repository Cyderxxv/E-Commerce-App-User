import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    await Future.delayed(const Duration(seconds: 1));
    // Mock user data
    final user = UserModel(
      userId: '1',
      fullname: event.data.fullname,
      phoneNumber: event.data.phoneNumber,
      email: event.data.email,
      address: '123 Mock St',
      dateOfBirth: '2000-01-01',
      avatarUrl: null,
      gender: 'male',
      status: 'active',
      createdAt: DateTime.now(),
    );
    emit(RegisterState(success: true, userModel: user));
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    await Future.delayed(const Duration(seconds: 1));
    // Mock Login
    if (event.data.password == '123456') {
      final user = UserModel(
        userId: '1',
        fullname: 'Nguyen Van A',
        phoneNumber: event.data.phoneNumber,
        email: 'mock@email.com',
        address: '123 Mock St',
        dateOfBirth: '2000-01-01',
        avatarUrl: null,
        gender: 'male',
        status: 'active',
        createdAt: DateTime.now(),
      );
      emit(LoginState(success: true, userModel: user));
    } else {
      emit(LoginState(success: false, userModel: null));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    await Future.delayed(const Duration(seconds: 1));
    emit(ForgotPasswordState(success: true, message: 'OTP sent to ${event.data.phoneNumber}'));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(LogoutState(success: true));
  }
}

