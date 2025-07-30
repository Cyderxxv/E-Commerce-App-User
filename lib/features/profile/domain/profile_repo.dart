import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_network.dart';
import '../../auth/domain/auth_repo.dart';

class ProfileRepository {

  /// Get auth token from storage
  Future<String> _getAuthToken() async {
    // Get token from AuthRepository
    return AuthRepository.instance.getAuthToken() ?? '';
  }

  /// Get current user ID from AuthRepository
  String? _getCurrentUserId() {
    final currentUser = AuthRepository.instance.getCurrentUserSync();
    return currentUser?.userId;
  }

  /// Get current user profile from backend API
  Future<ProfileData> getCurrentProfile() async {
    try {
      // Get current user ID from AuthRepository
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('No user logged in');
      }
      
      // Initialize Dio network with base URL
      DioNetwork.instant.init(AppConstants.baseUrl);
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await _getAuthToken()}',
      };
      
      final response = await DioNetwork.instant.dio.get(
        '/profile',
        queryParameters: {'user_id': userId},
        options: Options(headers: headers),
      );
      
      if (response.statusCode == 200) {
        final userData = response.data['data'];
        // print('📋 Backend profile data received:');
        // print('  - name: ${userData['name']}');
        // print('  - email: ${userData['email']}');
        // print('  - date_of_birth: ${userData['date_of_birth']}');
        // print('  - gender: ${userData['gender']}');
        // print('  - address: ${userData['address']}');
        
        return ProfileData(
          name: userData['name'] ?? 'Unknown User',
          email: userData['email'] ?? 'unknown@email.com',
          avatarUrl: userData['photo'] ?? 'https://i.pravatar.cc/150?img=3',
          appVersion: '1.0.0',
          dateOfBirth: userData['date_of_birth'],
          gender: userData['gender'],
          address: userData['address'],
        );
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('❌ Get Profile Error: $e');
      // Return fallback data on error
      return ProfileData(
        name: 'User',
        email: 'user@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        appVersion: '1.0.0',
        dateOfBirth: null,
        gender: null,
        address: null,
      );
    }
  }

  /// Update user profile using backend API
  Future<ProfileUpdateResult> updateProfile({
    required String name,
    required String email,
    required String avatarUrl,
    String? dateOfBirth,
    String? gender,
    String? address,
  }) async {
    try {
      // Get current user ID from AuthRepository
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('No user logged in');
      }
      
      // Initialize Dio network with base URL
      DioNetwork.instant.init(AppConstants.baseUrl);
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await _getAuthToken()}',
      };
      
      final requestData = <String, dynamic>{
        'name': name,
        'email': email,
        'photo': avatarUrl,
        'full_name': name,
      };
      
      // Add optional fields if provided
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        try {
          // Parse date and format for Go backend (RFC3339)
          DateTime parsedDate;
          
          if (dateOfBirth.contains('T')) {
            // Already has time component
            parsedDate = DateTime.parse(dateOfBirth);
          } else {
            // Plain date format like "2003-07-28", add time
            parsedDate = DateTime.parse('${dateOfBirth}T00:00:00');
          }
          
          // Format for Go backend: YYYY-MM-DDTHH:MM:SSZ (RFC3339)
          final year = parsedDate.year.toString().padLeft(4, '0');
          final month = parsedDate.month.toString().padLeft(2, '0');
          final day = parsedDate.day.toString().padLeft(2, '0');
          final hour = parsedDate.hour.toString().padLeft(2, '0');
          final minute = parsedDate.minute.toString().padLeft(2, '0');
          final second = parsedDate.second.toString().padLeft(2, '0');
          
          final formattedDate = '${year}-${month}-${day}T${hour}:${minute}:${second}Z';
          requestData['date_of_birth'] = formattedDate;
          print('📅 Date of Birth formatted for Go backend: $formattedDate');
        } catch (e) {
          print('❌ Date parsing error: $e');
          // Fallback: manual format
          final cleanDate = dateOfBirth.split('T')[0]; // Get only date part
          requestData['date_of_birth'] = '${cleanDate}T00:00:00Z';
          print('📅 Fallback date format: ${requestData['date_of_birth']}');
        }
      }
      if (gender != null && gender.isNotEmpty) {
        requestData['gender'] = gender;
        print('👤 Gender set: $gender');
      }
      if (address != null && address.isNotEmpty) {
        requestData['address'] = address;
        print('🏠 Address set: $address');
      }
      
      print('🔄 Updating profile with data: $requestData');
      print('📋 Request details:');
      print('  - Name: $name');
      print('  - Email: $email');
      print('  - Avatar: $avatarUrl');
      print('  - Date of Birth: $dateOfBirth');
      print('  - Gender: $gender');
      print('  - Address: $address');
      print('  - Final request data: $requestData');
      
      final response = await DioNetwork.instant.dio.put(
        '/profile',
        queryParameters: {'user_id': userId},
        data: requestData,
        options: Options(headers: headers),
      );
      
      print('✅ Profile update response: ${response.statusCode} - ${response.data}');
      
      if (response.statusCode == 200) {
        final userData = response.data['data'];
        final message = response.data['message'] ?? 'Profile updated successfully';
        
        final updatedProfile = ProfileData(
          name: userData['name'] ?? name,
          email: userData['email'] ?? email,
          avatarUrl: userData['photo'] ?? avatarUrl,
          appVersion: '1.0.0',
          dateOfBirth: userData['date_of_birth'] ?? dateOfBirth,
          gender: userData['gender'] ?? gender,
          address: userData['address'] ?? address,
        );
        
        return ProfileUpdateResult(
          success: true,
          message: message,
          profileData: updatedProfile,
        );
      } else {
        return ProfileUpdateResult(
          success: false,
          message: 'Failed to update profile',
          profileData: ProfileData(
            name: name,
            email: email,
            avatarUrl: avatarUrl,
            appVersion: '1.0.0',
            dateOfBirth: dateOfBirth,
            gender: gender,
            address: address,
          ),
        );
      }
    } catch (e) {
      print('❌ Update Profile Error: $e');
      String errorMessage = 'Failed to update profile';
      
      if (e is DioException && e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> && responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        }
      }
      
      return ProfileUpdateResult(
        success: false,
        message: errorMessage,
        profileData: ProfileData(
          name: name,
          email: email,
          avatarUrl: avatarUrl,
          appVersion: '1.0.0',
          dateOfBirth: dateOfBirth,
          gender: gender,
          address: address,
        ),
      );
    }
  }

  /// Get app version
  Future<String> getAppVersion() async {
    return '1.0.0'; // Static app version
  }

  /// Update avatar only using backend API
  Future<ProfileUpdateResult> updateAvatar(String avatarUrl) async {
    try {
      // Get current profile first
      final currentProfile = await getCurrentProfile();
      
      // Update only avatar
      return await updateProfile(
        name: currentProfile.name,
        email: currentProfile.email,
        avatarUrl: avatarUrl,
        dateOfBirth: currentProfile.dateOfBirth,
        gender: currentProfile.gender,
        address: currentProfile.address,
      );
    } catch (e) {
      print('❌ Update Avatar Error: $e');
      return ProfileUpdateResult(
        success: false,
        message: 'Failed to update avatar',
        profileData: ProfileData(
          name: 'User',
          email: 'user@example.com',
          avatarUrl: avatarUrl,
          appVersion: '1.0.0',
          dateOfBirth: null,
          gender: null,
          address: null,
        ),
      );
    }
  }

  /// Change email using backend API
  Future<ProfileUpdateResult> changeEmail(String newEmail) async {
    try {
      // Mock email validation
      if (!newEmail.contains('@')) {
        return ProfileUpdateResult(
          success: false,
          message: 'Invalid email format',
          profileData: ProfileData(
            name: 'User',
            email: newEmail,
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
            appVersion: '1.0.0',
            dateOfBirth: null,
            gender: null,
            address: null,
          ),
        );
      }
      
      // Get current profile first
      final currentProfile = await getCurrentProfile();
      
      // Update only email
      return await updateProfile(
        name: currentProfile.name,
        email: newEmail,
        avatarUrl: currentProfile.avatarUrl,
        dateOfBirth: currentProfile.dateOfBirth,
        gender: currentProfile.gender,
        address: currentProfile.address,
      );
    } catch (e) {
      print('❌ Change Email Error: $e');
      return ProfileUpdateResult(
        success: false,
        message: 'Failed to update email',
        profileData: ProfileData(
          name: 'User',
          email: newEmail,
          avatarUrl: 'https://i.pravatar.cc/150?img=3',
          appVersion: '1.0.0',
          dateOfBirth: null,
          gender: null,
          address: null,
        ),
      );
    }
  }

  /// Get user statistics using backend API
  Future<UserStatistics> getUserStatistics() async {
    try {
      print('📊 Fetching user statistics from backend...');
      
      // Initialize Dio network
      await DioNetwork.instant.init(AppConstants.baseUrl);
      
      final response = await DioNetwork.instant.dio.get(
        '/user/statistics',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await _getAuthToken()}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return UserStatistics(
          totalOrders: data['total_orders'] ?? 0,
          totalSpent: (data['total_spent'] ?? 0.0).toDouble(),
          wishlistCount: data['wishlist_count'] ?? 0,
          reviewsCount: data['reviews_count'] ?? 0,
          memberSince: data['member_since'] != null 
            ? DateTime.parse(data['member_since'])
            : DateTime.now().subtract(const Duration(days: 365)),
        );
      } else {
        print('❌ Failed to get statistics: ${response.statusCode}');
        return _getMockStatistics();
      }
    } catch (e) {
      print('❌ Statistics Error: $e');
      return _getMockStatistics();
    }
  }

  /// Get mock statistics as fallback
  UserStatistics _getMockStatistics() {
    return UserStatistics(
      totalOrders: 25,
      totalSpent: 125000000,
      wishlistCount: 8,
      reviewsCount: 12,
      memberSince: DateTime.now().subtract(const Duration(days: 365)),
    );
  }
}

/// Profile data model
class ProfileData {
  final String name;
  final String email;
  final String avatarUrl;
  final String appVersion;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  ProfileData({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
    this.dateOfBirth,
    this.gender,
    this.address,
  });
}

/// Result class for profile update operations
class ProfileUpdateResult {
  final bool success;
  final String message;
  final ProfileData profileData;

  ProfileUpdateResult({
    required this.success,
    required this.message,
    required this.profileData,
  });
}

/// User statistics model
class UserStatistics {
  final int totalOrders;
  final double totalSpent;
  final int wishlistCount;
  final int reviewsCount;
  final DateTime memberSince;

  UserStatistics({
    required this.totalOrders,
    required this.totalSpent,
    required this.wishlistCount,
    required this.reviewsCount,
    required this.memberSince,
  });
}
