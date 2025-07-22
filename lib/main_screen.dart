import 'package:cyder_store/features/cart/pages/cart_wrapper.dart';
import 'package:flutter/material.dart';
import 'features/home/pages/home_page.dart';
import 'features/profile/pages/profile_wrapper.dart';
import 'core/widgets/bottom_nav_bar.dart';
import 'core/services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        } else {
          DateTime now = DateTime.now();
          if (_lastBackPressed == null ||
              now.difference(_lastBackPressed!) > const Duration(seconds: 1)) {
            _lastBackPressed = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press back again to exit the app')),
            );
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(),
            CartWrapper(),
            ProfileWrapper(),
          ],
        ),
        bottomNavigationBar: ListenableBuilder(
          listenable: AuthService(),
          builder: (context, child) {
            return BottomNavBar(
              currentIndex: _currentIndex,
              cartCount: AuthService().isLoggedIn ? 0 : 0, // Will be updated with actual cart count when needed
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
