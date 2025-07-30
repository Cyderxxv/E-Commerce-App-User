import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String avatarUrl;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  const UpdateProfileEvent({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, dateOfBirth, gender, address];
}
