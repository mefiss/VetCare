import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/environment.dart';
import '../../../../data/mock_data.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';

/// Municipality catalog.
abstract class CatalogRepository {
  Future<List<String>> getMunicipalities();
}

class MockCatalogRepository implements CatalogRepository {
  @override
  Future<List<String>> getMunicipalities() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.municipalities;
  }
}

class ApiCatalogRepository implements CatalogRepository {
  final ApiClient _client;

  ApiCatalogRepository(this._client);

  @override
  Future<List<String>> getMunicipalities() async {
    final response = await _client.dio.get('/api/catalogs/municipalities');
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return apiResponse.data
        .map((item) => (item as Map<String, dynamic>)['name'] as String)
        .toList();
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  if (Environment.useMockData) return MockCatalogRepository();
  return ApiCatalogRepository(ref.read(apiClientProvider));
});
