import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String avatarUrl;
  final String appVersion;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, appVersion, dateOfBirth, gender, address];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateSuccess extends ProfileState {
  final String name;
  final String email;
  final String avatarUrl;
  final String appVersion;
  final String message;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  const ProfileUpdateSuccess({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
    required this.message,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, appVersion, message, dateOfBirth, gender, address];
}
