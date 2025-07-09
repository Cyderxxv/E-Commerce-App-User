import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  static const Color kBlue = Color(0xFF3DDCFC);

  @override
  Widget build(BuildContext context) {
    final iconList = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.cartShopping,
      FontAwesomeIcons.user,
    ];
    final labelList = [
      'Home',
      'My Cart',
      'My Account',
    ];
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        return Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Container(
            decoration: isActive
                ? BoxDecoration(
                    border: Border.all(color: kBlue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  iconList[index],
                  color: isActive ? kBlue : Colors.grey,
                  size: 20,
                ),
                const SizedBox(height: 5),
                Text(
                  labelList[index],
                  style: TextStyle(
                    color: isActive ? kBlue : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      height: 76,
      activeIndex: currentIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 24,
      rightCornerRadius: 24,
      onTap: onTap,
    );
  }
}