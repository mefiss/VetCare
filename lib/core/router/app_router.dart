import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/pets/presentation/screens/pets_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/booking/presentation/screens/select_pet_screen.dart';
import '../../features/booking/presentation/screens/select_service_screen.dart';
import '../../features/booking/presentation/screens/address_screen.dart';
import '../../features/booking/presentation/screens/vet_list_screen.dart';
import '../../features/booking/presentation/screens/vet_profile_screen.dart';
import '../../features/booking/presentation/screens/calendar_screen.dart';
import '../../features/booking/presentation/screens/confirmation_screen.dart';
import '../widgets/petcare_bottom_nav.dart';

// Navigation key for root navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// App router configuration with bottom nav shell + booking flow routes.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // ── Bottom Nav Shell ──
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => _ShellScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/pets', builder: (_, __) => const PetsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/alerts', builder: (_, __) => const AlertsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/profile', builder: (_, __) => const ProfileScreen()),
          ],
        ),
      ],
    ),

    // ── Booking Flow (no bottom nav) ──
    GoRoute(
      path: '/booking/select-pet',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SelectPetScreen(),
    ),
    GoRoute(
      path: '/booking/select-service',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SelectServiceScreen(),
    ),
    GoRoute(
      path: '/booking/address',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AddressScreen(),
    ),
    GoRoute(
      path: '/booking/vet-list',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const VetListScreen(),
    ),
    GoRoute(
      path: '/booking/vet-profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const VetProfileScreen(),
    ),
    GoRoute(
      path: '/booking/calendar',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/booking/confirmation',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ConfirmationScreen(),
    ),
  ],
);

/// Shell scaffold that wraps tab screens with bottom navigation.
class _ShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ShellScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: PetCareBottomNav(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          alertsBadgeCount: 2,
        ),
      );
}
