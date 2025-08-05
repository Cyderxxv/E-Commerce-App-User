import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository.instance;
  
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<LogoutEvent>(_onLogout);
  }

  // AuthBloc({AuthRepositorysitory? AuthRepositorysitory})
  //     : AuthRepository = AuthRepositorysitory ?? AuthRepositorysitory(),
  //       super(AuthUnauthenticated()) {
  //   on<CheckAuthEvent>(_onCheckAuth);
  //   on<RegisterEvent>(_onRegister);
  //   on<LoginEvent>(_onLogin);
  //   on<ForgotPasswordEvent>(_onForgotPassword);
  //   on<LogoutEvent>(_onLogout);
  // }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    try {
      // Check if user is already logged in using instance method
      final isLoggedIn = _authRepository.isLoggedIn();      
      if (isLoggedIn) {
        // Get current user using instance method
        final user = _authRepository.getCurrentUserSync();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
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
        // After successful login, emit authenticated state
        if (result.user != null) {
          emit(AuthAuthenticated(user: result.user!));
        }
      } else {
        emit(LoginState(
          success: false,
          userModel: null,
          message: result.message,
        ));
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(LoginState(
        success: false,
        userModel: null,
        message: 'An error occurred during login',
      ));
      emit(AuthUnauthenticated());
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
      
      // After logout, emit unauthenticated state
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(LogoutState(
        success: false,
        message: 'An error occurred during logout',
      ));
    }
  }
}

