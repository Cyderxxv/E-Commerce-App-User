import '../models/user_model.dart';
import '../models/input_login_model.dart';
import '../models/input_register_model.dart';
import '../models/input_forgot_password_model.dart';

class AuthRepository {
  // Mock userdata
  static final UserModel _mockUser = UserModel(
    userId: 'user_001',
    fullname: 'Khiem Pham',
    phoneNumber: '+84987654321',
    email: 'phamnguyengiakhiem@gmail.com',
    address: '123 Main Street, Ho Chi Minh City',
    dateOfBirth: '1995-05-15',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    gender: 'Male',
    status: 'Active',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  /// Login with phone number and password
  Future<AuthResult> login(InputLoginModel loginData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock login validation  
    if (loginData.password == '123456') {
      return AuthResult(
        success: true,
        user: _mockUser,
        message: 'Login successful',
      );
    } else {
      return AuthResult(
        success: false,
        user: null,
        message: 'Invalid phone number or password',
      );
    }
  }

  /// Register new user account
  Future<AuthResult> register(InputRegisterModel registerData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock registration - always success for demo
    final newUser = UserModel(
      userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullname: registerData.fullname,
      phoneNumber: registerData.phoneNumber,
      email: registerData.email,
      status: 'Active',
      createdAt: DateTime.now(),
    );
    
    return AuthResult(
      success: true,
      user: newUser,
      message: 'Registration successful',
    );
  }

  /// Send forgot password OTP
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
    
    return AuthResult(
      success: true,
      user: null,
      message: 'Logout successful',
    );
  }

  /// Verify OTP code
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
    return _mockUser;
  }
}

/// Result class for authentication operations
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