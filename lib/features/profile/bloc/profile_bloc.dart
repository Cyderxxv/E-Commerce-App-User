import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../domain/profile_repo.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
 ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  } 

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    
    try {
      final profileData = await ProfileRepository().getCurrentProfile();
      emit(ProfileLoaded(
        name: profileData.name,
        email: profileData.email,
        avatarUrl: profileData.avatarUrl,
        appVersion: profileData.appVersion,
        dateOfBirth: profileData.dateOfBirth,
        gender: profileData.gender,
        address: profileData.address,
      ));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    
    try {
      final result = await ProfileRepository().updateProfile(
        name: event.name,
        email: event.email,
        avatarUrl: event.avatarUrl,
        dateOfBirth: event.dateOfBirth,
        gender: event.gender,
        address: event.address,
      );
      
      if (result.success) {
        emit(ProfileUpdateSuccess(
          name: result.profileData.name,
          email: result.profileData.email,
          avatarUrl: result.profileData.avatarUrl,
          appVersion: result.profileData.appVersion,
          message: result.message,
          dateOfBirth: result.profileData.dateOfBirth,
          gender: result.profileData.gender,
          address: result.profileData.address,
        ));
        
        // After showing success message, emit loaded state
        emit(ProfileLoaded(
          name: result.profileData.name,
          email: result.profileData.email,
          avatarUrl: result.profileData.avatarUrl,
          appVersion: result.profileData.appVersion,
          dateOfBirth: result.profileData.dateOfBirth,
          gender: result.profileData.gender,
          address: result.profileData.address,
        ));
      } else {
        emit(ProfileError(message: result.message));
      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to update profile: ${e.toString()}'));
    }
  }
}
