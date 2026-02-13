import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/catalog_repository.dart';

final municipalitiesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(catalogRepositoryProvider).getMunicipalities();
});
