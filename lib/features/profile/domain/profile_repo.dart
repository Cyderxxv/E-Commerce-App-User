class ProfileRepository {
  // Mock profile data
  ProfileData _currentProfile = ProfileData(
    name: 'Khiem Pham',
    email: 'phamnguyengiakhiem@gmail.com',
    avatarUrl: 'https://scontent.fsgn2-5.fna.fbcdn.net/v/t39.30808-6/500419032_1790214701525237_1171719718902869541_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGA1yB7EhuuafrnRe8OChDkPkllL8YccZM-SWUvxhxxk__LGF1R_6Dt4De2MSFkv3vshLeZsKiTYtvovNwO07vm&_nc_ohc=g1TEkLwbnv4Q7kNvwHCJQFF&_nc_oc=Admuc3YCQvXtVP2DMRY_bIdwPhfFHIrqxWcIJjACy6372R1TKGMPulHSgM_pHp7tFrs&_nc_zt=23&_nc_ht=scontent.fsgn2-5.fna&_nc_gid=SSKNowL7lPEVWPnW9Gl54w&oh=00_AfT8VsxY6t0UyCHSeTHO8kjUUdgXQtICqnBbUQCQkGeiPw&oe=6884DABE',
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
