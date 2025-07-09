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

  const UpdateProfileEvent({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl];
}
