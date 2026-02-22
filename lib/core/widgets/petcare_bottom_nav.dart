import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bottom navigation bar with 4 tabs and optional badge on Alerts.
class PetCareBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int alertsBadgeCount;

  const PetCareBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.alertsBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            label: 'Mascotas',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: alertsBadgeCount > 0,
              label: Text(
                '$alertsBadgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              backgroundColor: AppColors.error,
              child: const Icon(Icons.notifications_rounded),
            ),
            label: 'Alertas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      );
}
