import 'package:cyder_store/features/cart/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'features/home/pages/home_page.dart';
import 'features/profile/pages/profile_page.dart';
import 'core/widgets/bottom_nav_bar.dart';

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
          children: const [
            HomePage(),
            CartPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
