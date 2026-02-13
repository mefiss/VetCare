import 'package:json_annotation/json_annotation.dart';

part 'create_appointment_dto.g.dart';

/// Maps POST /api/booking/appointments request body.
@JsonSerializable(createFactory: false)
class CreateAppointmentDto {
  final List<String> petIds;
  final String serviceType;
  final String veterinarianId;
  final String date;
  final String startTime;
  final String municipality;
  final String address;
  final String? addressNotes;

  const CreateAppointmentDto({
    required this.petIds,
    required this.serviceType,
    required this.veterinarianId,
    required this.date,
    required this.startTime,
    required this.municipality,
    required this.address,
    this.addressNotes,
  });

  Map<String, dynamic> toJson() => _$CreateAppointmentDtoToJson(this);
}
