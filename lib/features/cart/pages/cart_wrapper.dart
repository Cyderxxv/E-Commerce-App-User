import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import 'cart_page.dart';
import 'cart_login_page.dart';

class CartWrapper extends StatelessWidget {
  const CartWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService(),
      builder: (context, child) {
        if (AuthService().isLoggedIn) {
          return const CartPage();
        } else {
          return const CartLoginPage();
        }
      },
    );
  }
}
