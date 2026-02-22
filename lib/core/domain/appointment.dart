import 'package:flutter/material.dart';
import 'appointment_status.dart';
import 'service_type.dart';
import 'species.dart';

class Appointment {
  final String id;
  final String petName;
  final Species petSpecies;
  final ServiceType serviceType;
  final String vetName;
  final DateTime scheduledDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final AppointmentStatus status;

  const Appointment({
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

  String get serviceLabel =>
      serviceType == ServiceType.vaccination ? 'Vacunación Anual' : 'Desparasitación';

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmada';
      case AppointmentStatus.completed:
        return 'Completada';
      case AppointmentStatus.cancelledByOwner:
        return 'Cancelada';
      case AppointmentStatus.cancelledByVet:
        return 'Cancelada por vet';
    }
  }
}
