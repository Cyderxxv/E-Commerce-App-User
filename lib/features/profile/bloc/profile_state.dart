import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String email;
  final String avatarUrl;
  final String appVersion;

  const ProfileState({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, appVersion];
}
