import 'package:json_annotation/json_annotation.dart';

part 'dashboard_dto.g.dart';

/// Maps GET /api/owner/dashboard response.
@JsonSerializable(createToJson: false)
class DashboardDto {
  final List<ReminderDto> reminders;
  final List<AppointmentSummaryDto> upcomingAppointments;

  const DashboardDto({
    required this.reminders,
    required this.upcomingAppointments,
  });

  factory DashboardDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ReminderDto {
  final String petId;
  final String petName;
  final String species;
  final String message;
  final bool isOverdue;

  const ReminderDto({
    required this.petId,
    required this.petName,
    required this.species,
    required this.message,
    required this.isOverdue,
  });

  factory ReminderDto.fromJson(Map<String, dynamic> json) =>
      _$ReminderDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class AppointmentSummaryDto {
  final String id;
  final String petName;
  final String petSpecies;
  final String serviceType;
  final String vetName;
  final String scheduledDate;
  final String startTime;
  final String endTime;
  final String status;

  const AppointmentSummaryDto({
    required this.id,
    required this.petName,
    required this.petSpecies,
    required this.serviceType,
    required this.vetName,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory AppointmentSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSummaryDtoFromJson(json);
}
