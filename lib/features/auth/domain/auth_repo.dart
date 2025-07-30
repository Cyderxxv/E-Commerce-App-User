import 'package:cyder_store/core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/input_login_model.dart';
import '../models/input_register_model.dart';
import '../models/input_forgot_password_model.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_network.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;
  static bool _isLoggedIn = false;
  static UserModel? _currentUser;
  static String? _authToken;

  /// Login with email and password (API integration)
  Future<AuthResult> login(InputLoginModel loginData) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      DioNetwork.instant.init(AppConstants.baseUrl);
      final response = await DioNetwork.instant.dio.post(
        '/auth/login',
        data: {
          'email': loginData.phoneNumber,
          'password': loginData.password,
        },
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final userData = data['data']['user'];
        final token = data['data']['token'];
        
        _currentUser = UserModel(
          userId: userData['id'].toString(),
          fullname: userData['name'] ?? '',
          phoneNumber: userData['phone_number'] ?? '',
          email: userData['email'] ?? '',
          address: userData['address'] ?? '',
          dateOfBirth: userData['date_of_birth'] ?? '',
          avatarUrl: userData['photo'] ?? 'photo',
          gender: userData['gender'] ?? '',
          status: userData['status'] ?? 'Active',
          createdAt: DateTime.tryParse(userData['created_at'] ?? '') ?? DateTime.now(),
        );
        
        _authToken = token;
        _isLoggedIn = true;
        
        return AuthResult(
          success: true,
          user: _currentUser,
          message: data['message'] ?? 'Login successful',
        );
      } else {
        return AuthResult(
          success: false,
          user: null,
          message: response.data['error'] ?? 'Login failed',
        );
      }
    } catch (e) {      
      if (e is DioException) {
        String errorMessage = 'Login failed';        
        if (e.response != null) {
          final statusCode = e.response?.statusCode;
          final responseData = e.response?.data;
          
          if (statusCode == 404) {
            errorMessage = 'API endpoint not found - check backend routes';
          } else if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['error'] ?? responseData['message'] ?? 'Login failed';
          } else {
            errorMessage = 'Server error (${statusCode})';
          }
        } else if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Connection timeout - check your internet';
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Server response timeout';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Cannot connect to server - make sure backend is running';
        } else {
          errorMessage = 'Network error: ${e.message}';
        }
        
        return AuthResult(
          success: false,
          user: null,
          message: errorMessage,
        );
      }
      
      return AuthResult(
        success: false,
        user: null,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Register (API integration)
  Future<AuthResult> register(InputRegisterModel registerData) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      DioNetwork.instant.init(AppConstants.baseUrl);
      final response = await DioNetwork.instant.dio.post(
        '/auth/register',
        data: {
          'name': registerData.fullname,
          'email': registerData.email,
          'phone_number': registerData.phoneNumber,
          'password': registerData.password,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final userData = data['data']['user'];
        final token = data['data']['token'];
        
        final newUser = UserModel(
          userId: userData['id'].toString(),
          fullname: userData['name'] ?? '',
          phoneNumber: userData['phone_number'] ?? '',
          email: userData['email'] ?? '',
          address: userData['address'] ?? '',
          dateOfBirth: userData['date_of_birth'] ?? '',
          avatarUrl: userData['photo'] ?? 'https://i.pravatar.cc/150?img=3',
          gender: userData['gender'] ?? '',
          status: userData['status'] ?? 'Active',
          createdAt: DateTime.tryParse(userData['created_at'] ?? '') ?? DateTime.now(),
        );
        
        _currentUser = newUser;
        _authToken = token;
        _isLoggedIn = true;
        
        return AuthResult(
          success: true,
          user: newUser,
          message: data['message'] ?? 'Registration successful',
        );
      } else {
        return AuthResult(
          success: false,
          user: null,
          message: response.data['error'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      if (e is DioException) {
        String errorMessage = 'Registration failed';
        if (e.response != null) {
          final statusCode = e.response?.statusCode;
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['error'] ?? responseData['message'] ?? 'Registration failed';
          } else {
            errorMessage = 'Server error (${statusCode})';
          }
        } else if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Connection timeout - check your internet';
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Server response timeout';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Cannot connect to server - make sure backend is running';
        } else {
          errorMessage = 'Network error: ${e.message}';
        }
        return AuthResult(
          success: false,
          user: null,
          message: errorMessage,
        );
      }
      return AuthResult(
        success: false,
        user: null,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Send forgot password OTP (Mock for now)
  Future<AuthResult> forgotPassword(ForgotPasswordModel forgotData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock forgot password - always success for demo
    return AuthResult(
      success: true,
      user: null,
      message: 'OTP sent successfully to ${forgotData.phoneNumber}',
    );
  }

  /// Logout user
  Future<AuthResult> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _isLoggedIn = false;
    _currentUser = null;
    _authToken = null;
    
    return AuthResult(
      success: true,
      user: null,
      message: 'Logout successful',
    );
  }

  /// Get auth token
  String? getAuthToken() {
    return _authToken;
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _isLoggedIn;
  }

  /// Verify OTP code (Mock for now)
  Future<AuthResult> verifyOTP(String phoneNumber, String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock OTP verification - accept "123456" as valid OTP
    if (otpCode == '123456') {
      return AuthResult(
        success: true,
        user: null,
        message: 'OTP verified successfully',
      );
    } else {
      return AuthResult(
        success: false,
        user: null,
        message: 'Invalid OTP code',
      );
    }
  }

  /// Get current user profile
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  /// Get current user synchronously for BLoC
  UserModel? getCurrentUserSync() {
    return _currentUser;
  }
}

class AuthResult {
  final bool success;
  final UserModel? user;
  final String message;

  AuthResult({
    required this.success,
    required this.user,
    required this.message,
  });
}