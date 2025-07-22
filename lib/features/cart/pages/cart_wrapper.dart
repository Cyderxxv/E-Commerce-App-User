import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import 'cart_page.dart';
import 'cart_login_page.dart';

class CartWrapper extends StatefulWidget {
  const CartWrapper({Key? key}) : super(key: key);

  @override
  State<CartWrapper> createState() => _CartWrapperState();
}

class _CartWrapperState extends State<CartWrapper> {
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
          return const CartPage();
        } else if (state is AuthUnauthenticated) {
          return const CartLoginPage();
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
