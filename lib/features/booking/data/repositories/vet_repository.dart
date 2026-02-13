import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/environment.dart';
import '../../../../data/mock_data.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../dtos/vet_dto.dart';
import '../dtos/slot_dto.dart';

/// Vet search, profile, and available slots.
abstract class VetRepository {
  Future<List<Vet>> searchVets({
    required String municipality,
    required String serviceType,
    required String date,
    required int petCount,
  });

  Future<Vet> getVetProfile(String vetId);

  Future<List<TimeOfDay>> getAvailableSlots({
    required String vetId,
    required String date,
    required int durationMinutes,
  });
}

class MockVetRepository implements VetRepository {
  @override
  Future<List<Vet>> searchVets({
    required String municipality,
    required String serviceType,
    required String date,
    required int petCount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.vets
        .where((v) => v.coverageMunicipalities.contains(municipality))
        .toList();
  }

  @override
  Future<Vet> getVetProfile(String vetId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.vets.firstWhere((v) => v.id == vetId);
  }

  @override
  Future<List<TimeOfDay>> getAvailableSlots({
    required String vetId,
    required String date,
    required int durationMinutes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final vet = MockData.vets.firstWhere((v) => v.id == vetId);
    return vet.availableSlots;
  }
}

class ApiVetRepository implements VetRepository {
  final ApiClient _client;

  ApiVetRepository(this._client);

  @override
  Future<List<Vet>> searchVets({
    required String municipality,
    required String serviceType,
    required String date,
    required int petCount,
  }) async {
    final response = await _client.dio.get(
      '/api/booking/veterinarians',
      queryParameters: {
        'municipality': municipality,
        'serviceType': serviceType,
        'date': date,
        'petCount': petCount,
      },
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );

    return apiResponse.data.map((item) {
      final dto = VetDto.fromJson(item as Map<String, dynamic>);
      return _mapVetDto(dto);
    }).toList();
  }

  @override
  Future<Vet> getVetProfile(String vetId) async {
    final response =
        await _client.dio.get('/api/booking/veterinarians/$vetId');
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    final dto = VetDto.fromJson(apiResponse.data);
    return _mapVetDto(dto);
  }

  @override
  Future<List<TimeOfDay>> getAvailableSlots({
    required String vetId,
    required String date,
    required int durationMinutes,
  }) async {
    final response = await _client.dio.get(
      '/api/booking/veterinarians/$vetId/slots',
      queryParameters: {
        'date': date,
        'durationMinutes': durationMinutes,
      },
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    final dto = SlotDto.fromJson(apiResponse.data);

    return dto.availableSlots.map((slot) {
      final parts = slot.startTime.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }).toList();
  }

  Vet _mapVetDto(VetDto dto) {
    return Vet(
      id: dto.id,
      name: dto.name,
      rating: dto.rating,
      totalReviews: dto.totalReviews,
      coverageMunicipalities: dto.coverageMunicipalities,
      bio: dto.bio ?? '',
      specialties: dto.specialties ?? [],
      phone: dto.phone ?? '',
      reviews: (dto.reviews ?? [])
          .map((r) => Review(
                id: r.id,
                authorName: r.authorName,
                rating: r.rating,
                comment: r.comment,
                timeAgo: r.timeAgo,
              ))
          .toList(),
      availableSlots: [],
      nextAvailable: dto.nextAvailable ?? '',
    );
  }
}

final vetRepositoryProvider = Provider<VetRepository>((ref) {
  if (Environment.useMockData) return MockVetRepository();
  return ApiVetRepository(ref.read(apiClientProvider));
});
