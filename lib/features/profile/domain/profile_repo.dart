class ProfileRepository {
  // Mock profile data
  ProfileData _currentProfile = ProfileData(
    name: 'Khiem Pham',
    email: 'phamnguyengiakhiem@gmail.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    appVersion: '0.1.1',
  );

  /// Get current user profile
  Future<ProfileData> getCurrentProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentProfile;
  }

  /// Update user profile
  Future<ProfileUpdateResult> updateProfile({
    required String name,
    required String email,
    required String avatarUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      _currentProfile = ProfileData(
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        appVersion: _currentProfile.appVersion,
      );
      
      return ProfileUpdateResult(
        success: true,
        message: 'Profile updated successfully',
        profileData: _currentProfile,
      );
    } catch (e) {
      return ProfileUpdateResult(
        success: false,
        message: 'Failed to update profile',
        profileData: _currentProfile,
      );
    }
  }

  /// Get app version
  Future<String> getAppVersion() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentProfile.appVersion;
  }

  /// Update avatar only
  Future<ProfileUpdateResult> updateAvatar(String avatarUrl) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      _currentProfile = ProfileData(
        name: _currentProfile.name,
        email: _currentProfile.email,
        avatarUrl: avatarUrl,
        appVersion: _currentProfile.appVersion,
      );
      
      return ProfileUpdateResult(
        success: true,
        message: 'Avatar updated successfully',
        profileData: _currentProfile,
      );
    } catch (e) {
      return ProfileUpdateResult(
        success: false,
        message: 'Failed to update avatar',
        profileData: _currentProfile,
      );
    }
  }

  /// Change email
  Future<ProfileUpdateResult> changeEmail(String newEmail) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Mock email validation
      if (!newEmail.contains('@')) {
        return ProfileUpdateResult(
          success: false,
          message: 'Invalid email format',
          profileData: _currentProfile,
        );
      }
      
      _currentProfile = ProfileData(
        name: _currentProfile.name,
        email: newEmail,
        avatarUrl: _currentProfile.avatarUrl,
        appVersion: _currentProfile.appVersion,
      );
      
      return ProfileUpdateResult(
        success: true,
        message: 'Email updated successfully',
        profileData: _currentProfile,
      );
    } catch (e) {
      return ProfileUpdateResult(
        success: false,
        message: 'Failed to update email',
        profileData: _currentProfile,
      );
    }
  }

  /// Get user statistics
  Future<UserStatistics> getUserStatistics() async {
    await Future.delayed(const Duration(milliseconds: 700));
    
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

  ProfileData({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
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
