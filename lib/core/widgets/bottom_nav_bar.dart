import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';

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
  static const Color kBackgroundColor = Color(0xFFF8F9FA);
  static const Color kGreyColor = Color(0xFF6C757D);

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

    return Container(
      height: 100,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Cart button (index 1)
          _buildNavItem(1, iconList[1], labelList[1]),
          // Center Home button (index 0)
          _buildCenterButton(iconList[0], labelList[0]),
          // Profile button (index 2)
          _buildNavItem(2, iconList[2], labelList[2]),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: isActive
                      ? BoxDecoration(
                          color: kBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: FaIcon(
                    icon,
                    color: isActive ? kBlue : kGreyColor,
                    size: 20,
                  ),
                ),
                // Cart count badge for cart item (index 1)
                if (index == 1 && cartCount > 0 && AuthService().isLoggedIn)
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
                        minWidth: 16,
                        minHeight: 16,
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
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? kBlue : kGreyColor,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(IconData icon, String label) {
    final isActive = currentIndex == 0;
    return GestureDetector(
      onTap: () => onTap(0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive 
                      ? [kBlue, kBlue.withOpacity(0.8)]
                      : [Colors.grey.shade400, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isActive ? kBlue : Colors.grey).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? kBlue : kGreyColor,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}