// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDto _$DashboardDtoFromJson(Map<String, dynamic> json) => DashboardDto(
      reminders: (json['reminders'] as List<dynamic>)
          .map((e) => ReminderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      upcomingAppointments: (json['upcomingAppointments'] as List<dynamic>)
          .map((e) => AppointmentSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ReminderDto _$ReminderDtoFromJson(Map<String, dynamic> json) => ReminderDto(
      petId: json['petId'] as String,
      petName: json['petName'] as String,
      species: json['species'] as String,
      message: json['message'] as String,
      isOverdue: json['isOverdue'] as bool,
    );

AppointmentSummaryDto _$AppointmentSummaryDtoFromJson(
        Map<String, dynamic> json) =>
    AppointmentSummaryDto(
      id: json['id'] as String,
      petName: json['petName'] as String,
      petSpecies: json['petSpecies'] as String,
      serviceType: json['serviceType'] as String,
      vetName: json['vetName'] as String,
      scheduledDate: json['scheduledDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
    );
