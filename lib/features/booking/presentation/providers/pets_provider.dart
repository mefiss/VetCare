import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models.dart';
import '../../data/repositories/pet_repository.dart';

final petsProvider = FutureProvider<List<Pet>>((ref) {
  return ref.read(petRepositoryProvider).getPets();
});
