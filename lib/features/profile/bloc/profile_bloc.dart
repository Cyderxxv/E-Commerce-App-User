import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : super(const ProfileState(
          name: 'Khim',
          email: 'khim@gmail.com',
          avatarUrl: 'https://i.pravatar.cc/150?img=3',
          appVersion: '0.1',
        )) {
    on<LoadProfileEvent>((event, emit) {
      // For mock, just emit the initial state
      emit(state);
    });
  }
}
