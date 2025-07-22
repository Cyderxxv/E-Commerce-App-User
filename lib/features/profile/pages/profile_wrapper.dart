import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import 'profile_page.dart';
import 'profile_login_page.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService(),
      builder: (context, child) {
        if (AuthService().isLoggedIn) {
          return const ProfilePage();
        } else {
          return const ProfileLoginPage();
        }
      },
    );
  }
}
