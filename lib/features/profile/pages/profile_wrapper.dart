import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import 'profile_page.dart';
import 'profile_login_page.dart';

class ProfileWrapper extends StatefulWidget {
  const ProfileWrapper({Key? key}) : super(key: key);

  @override
  State<ProfileWrapper> createState() => _ProfileWrapperState();
}

class _ProfileWrapperState extends State<ProfileWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when widget initializes
    context.read<AuthBloc>().add(const CheckAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const ProfilePage();
        } else if (state is AuthUnauthenticated) {
          return const ProfileLoginPage();
        } else {
          // Loading state or initial state
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
