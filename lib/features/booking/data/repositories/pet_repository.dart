import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/environment.dart';
import '../../../../data/mock_data.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../dtos/pet_dto.dart';

/// Owner's pets.
abstract class PetRepository {
  Future<List<Pet>> getPets();
}

class MockPetRepository implements PetRepository {
  @override
  Future<List<Pet>> getPets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.pets;
  }
}

class ApiPetRepository implements PetRepository {
  final ApiClient _client;

  ApiPetRepository(this._client);

  @override
  Future<List<Pet>> getPets() async {
    final response =
        await _client.dio.get('/api/owner/pets', queryParameters: {
      'includeHealth': true,
    });
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );

    return apiResponse.data.map((item) {
      final dto = PetDto.fromJson(item as Map<String, dynamic>);
      return Pet(
        id: dto.id,
        name: dto.name,
        species:
            dto.species.toUpperCase() == 'DOG' ? Species.dog : Species.cat,
        breed: dto.breed,
        nextVaccineDue: dto.nextVaccineDue,
        nextDewormingDue: dto.nextDewormingDue,
      );
    }).toList();
  }
}

final petRepositoryProvider = Provider<PetRepository>((ref) {
  if (Environment.useMockData) return MockPetRepository();
  return ApiPetRepository(ref.read(apiClientProvider));
});
