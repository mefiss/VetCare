import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models.dart';

/// App roles: pet owner or veterinarian.
enum AppRole { owner, vet }

/// Selected role. Null means no role selected yet.
final roleProvider = StateProvider<AppRole?>((ref) => null);

/// Holds the registered user. Null means no user has registered yet.
final userProvider = StateProvider<User?>((ref) => null);

/// Holds all registered pets (persisted in memory).
final registeredPetsProvider = StateProvider<List<Pet>>((ref) => []);

/// Holds the registered vet. Null means no vet has registered yet.
final registeredVetProvider = StateProvider<Vet?>((ref) => null);
