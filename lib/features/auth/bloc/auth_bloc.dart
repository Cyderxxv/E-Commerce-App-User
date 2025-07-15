import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    
    try {
      final result = await _authRepository.login(event.data);
      
      if (result.success) {
        emit(LoginState(
          success: true,
          userModel: result.user,
          message: result.message,
        ));
      } else {
        emit(LoginState(
          success: false,
          userModel: null,
          message: result.message,
        ));
      }
    } catch (e) {
      emit(LoginState(
        success: false,
        userModel: null,
        message: 'An error occurred during login',
      ));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    
    try {
      final result = await _authRepository.register(event.data);
      
      if (result.success) {
        emit(RegisterState(
          success: true,
          userModel: result.user,
          message: result.message,
        ));
      } else {
        emit(RegisterState(
          success: false,
          userModel: null,
          message: result.message,
        ));
      }
    } catch (e) {
      emit(RegisterState(
        success: false,
        userModel: null,
        message: 'An error occurred during registration',
      ));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    
    try {
      final result = await _authRepository.forgotPassword(event.data);
      
      emit(ForgotPasswordState(
        success: result.success,
        message: result.message,
      ));
    } catch (e) {
      emit(ForgotPasswordState(
        success: false,
        message: 'An error occurred while sending OTP',
      ));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
    
    try {
      final result = await _authRepository.logout();
      
      emit(LogoutState(
        success: result.success,
        message: result.message,
      ));
    } catch (e) {
      emit(LogoutState(
        success: false,
        message: 'An error occurred during logout',
      ));
    }
  }
}

