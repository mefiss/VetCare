import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/environment.dart';
import '../../../../core/network/api_client.dart';
import '../dtos/create_appointment_dto.dart';

/// Create appointments.
abstract class AppointmentRepository {
  Future<String> createAppointment(CreateAppointmentDto dto);
}

class MockAppointmentRepository implements AppointmentRepository {
  @override
  Future<String> createAppointment(CreateAppointmentDto dto) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'mock-appointment-id';
  }
}

class ApiAppointmentRepository implements AppointmentRepository {
  final ApiClient _client;

  ApiAppointmentRepository(this._client);

  @override
  Future<String> createAppointment(CreateAppointmentDto dto) async {
    final response = await _client.dio.post(
      '/api/booking/appointments',
      data: dto.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    final appointmentData = data['data'] as Map<String, dynamic>;
    return appointmentData['id'] as String;
  }
}

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  if (Environment.useMockData) return MockAppointmentRepository();
  return ApiAppointmentRepository(ref.read(apiClientProvider));
});
