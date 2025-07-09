class UserModel {
  final String userId;
  final String fullname;
  final String phoneNumber;
  final String email;
  final String? address;
  final String? dateOfBirth;
  final String? avatarUrl;
  final String? gender;
  final String? status;
  final DateTime? createdAt;

  UserModel({
    required this.userId,
    required this.fullname,
    required this.phoneNumber,
    required this.email,
    this.address,
    this.dateOfBirth,
    this.avatarUrl,
    this.gender,
    this.status,
    this.createdAt,
  });
}