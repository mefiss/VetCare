import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/environment.dart';
import '../../../../data/mock_data.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../dtos/dashboard_dto.dart';

/// Dashboard data (reminders + upcoming appointments).
abstract class DashboardRepository {
  Future<({List<PetReminder> reminders, List<Appointment> appointments})>
      getDashboard();
}

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<({List<PetReminder> reminders, List<Appointment> appointments})>
      getDashboard() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return (
      reminders: MockData.reminders,
      appointments: MockData.upcomingAppointments,
    );
  }
}

class ApiDashboardRepository implements DashboardRepository {
  final ApiClient _client;

  ApiDashboardRepository(this._client);

  @override
  Future<({List<PetReminder> reminders, List<Appointment> appointments})>
      getDashboard() async {
    final response = await _client.dio.get('/api/owner/dashboard');
    final apiResponse = ApiResponse<DashboardDto>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => DashboardDto.fromJson(json as Map<String, dynamic>),
    );
    final dto = apiResponse.data;

    final reminders = dto.reminders.map((r) {
      final species =
          r.species.toUpperCase() == 'DOG' ? Species.dog : Species.cat;
      return PetReminder(
        pet: Pet(
          id: r.petId,
          name: r.petName,
          species: species,
          breed: '',
        ),
        message: r.message,
        isOverdue: r.isOverdue,
      );
    }).toList();

    final appointments = dto.upcomingAppointments.map((a) {
      final parts = a.startTime.split(':');
      final endParts = a.endTime.split(':');
      return Appointment(
        id: a.id,
        petName: a.petName,
        petSpecies:
            a.petSpecies.toUpperCase() == 'DOG' ? Species.dog : Species.cat,
        serviceType: a.serviceType.toUpperCase() == 'VACCINATION'
            ? ServiceType.vaccination
            : ServiceType.deworming,
        vetName: a.vetName,
        scheduledDate: DateTime.parse(a.scheduledDate),
        startTime: TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        ),
        endTime: TimeOfDay(
          hour: int.parse(endParts[0]),
          minute: int.parse(endParts[1]),
        ),
        status: _parseStatus(a.status),
      );
    }).toList();

    return (reminders: reminders, appointments: appointments);
  }

  AppointmentStatus _parseStatus(String s) {
    switch (s.toUpperCase()) {
      case 'CONFIRMED':
        return AppointmentStatus.confirmed;
      case 'COMPLETED':
        return AppointmentStatus.completed;
      case 'CANCELLED_BY_OWNER':
        return AppointmentStatus.cancelledByOwner;
      case 'CANCELLED_BY_VET':
        return AppointmentStatus.cancelledByVet;
      default:
        return AppointmentStatus.confirmed;
    }
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  if (Environment.useMockData) return MockDashboardRepository();
  return ApiDashboardRepository(ref.read(apiClientProvider));
});
