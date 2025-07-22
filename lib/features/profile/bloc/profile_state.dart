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

  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, appVersion];
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

  const ProfileUpdateSuccess({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.appVersion,
    required this.message,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, appVersion, message];
}
