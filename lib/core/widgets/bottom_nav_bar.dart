import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

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
        Widget iconWidget;
        if (index == 1 && cartCount > 0) {
          iconWidget = Stack(
            clipBehavior: Clip.none,
            children: [
              FaIcon(
                iconList[index],
                color: isActive ? kBlue : Colors.grey,
                size: 20,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    cartCount > 99 ? '99+' : cartCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        } else {
          iconWidget = FaIcon(
            iconList[index],
            color: isActive ? kBlue : Colors.grey,
            size: 20,
          );
        }
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
                iconWidget,
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