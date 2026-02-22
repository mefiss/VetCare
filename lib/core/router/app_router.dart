import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/pets/presentation/screens/pets_screen.dart';
import '../../features/pets/presentation/screens/add_pet_screen.dart';
import '../../features/pets/presentation/screens/pet_detail_screen.dart';
import '../../features/pets/presentation/screens/edit_pet_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/booking/presentation/screens/select_pet_screen.dart';
import '../../features/booking/presentation/screens/select_service_screen.dart';
import '../../features/booking/presentation/screens/address_screen.dart';
import '../../features/booking/presentation/screens/vet_list_screen.dart';
import '../../features/booking/presentation/screens/vet_profile_screen.dart';
import '../../features/booking/presentation/screens/calendar_screen.dart';
import '../../features/booking/presentation/screens/confirmation_screen.dart';
import '../../features/registration/presentation/screens/role_selection_screen.dart';
import '../../features/registration/presentation/screens/user_registration_screen.dart';
import '../../features/registration/presentation/screens/pet_registration_screen.dart';
import '../../features/registration/presentation/screens/vet_registration_screen.dart';
import '../../features/registration/presentation/providers/registration_provider.dart';
import '../../features/vet_home/presentation/screens/vet_home_screen.dart';
import '../widgets/petcare_bottom_nav.dart';

// Navigation key for root navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// App router as a Riverpod provider so it can access user state for redirects.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/role-select',
    redirect: (context, state) {
      final role = ref.read(roleProvider);
      final user = ref.read(userProvider);
      final vet = ref.read(registeredVetProvider);
      final path = state.matchedLocation;

      // Allow role selection screen
      if (path == '/role-select') {
        // Already registered → go to appropriate home
        if (role == AppRole.owner && user != null) return '/home';
        if (role == AppRole.vet && vet != null) return '/vet-home';
        return null;
      }

      // No role selected → force role selection
      if (role == null) return '/role-select';

      // Owner flow
      if (role == AppRole.owner) {
        final isOnRegister = path.startsWith('/register');
        final isOnVetArea = path.startsWith('/vet-home');
        if (isOnVetArea) return '/home';
        if (user == null && !isOnRegister) return '/register';
        if (user != null && isOnRegister) return '/home';
      }

      // Vet flow
      if (role == AppRole.vet) {
        final isOnVetRegister = path == '/register/vet';
        final isOnVetHome = path == '/vet-home';
        if (vet == null && !isOnVetRegister) return '/register/vet';
        if (vet != null && isOnVetRegister) return '/vet-home';
        // Vet should only access vet-home and vet-register
        if (vet != null && !isOnVetHome) return '/vet-home';
      }

      return null;
    },
    routes: [
      // ── Role Selection ──
      GoRoute(
        path: '/role-select',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const RoleSelectionScreen(),
      ),

      // ── Owner Registration Flow (no bottom nav) ──
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const UserRegistrationScreen(),
      ),
      GoRoute(
        path: '/register/pet',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const PetRegistrationScreen(),
      ),

      // ── Vet Registration Flow (no bottom nav) ──
      GoRoute(
        path: '/register/vet',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const VetRegistrationScreen(),
      ),

      // ── Vet Home (no bottom nav for now) ──
      GoRoute(
        path: '/vet-home',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const VetHomeScreen(),
      ),

      // ── Owner Bottom Nav Shell ──
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
              GoRoute(
                  path: '/alerts', builder: (_, __) => const AlertsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/profile',
                  builder: (_, __) => const ProfileScreen()),
            ],
          ),
        ],
      ),

      // ── Edit Profile (no bottom nav) ──
      GoRoute(
        path: '/profile/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const EditProfileScreen(),
      ),

      // ── Add Pet (from Mis Mascotas tab, no bottom nav) ──
      GoRoute(
        path: '/pets/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AddPetScreen(),
      ),

      // ── Pet Detail (no bottom nav) ──
      GoRoute(
        path: '/pets/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => PetDetailScreen(
          petId: state.pathParameters['id']!,
        ),
      ),

      // ── Edit Pet (no bottom nav) ──
      GoRoute(
        path: '/pets/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => EditPetScreen(
          petId: state.pathParameters['id']!,
        ),
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
});

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
