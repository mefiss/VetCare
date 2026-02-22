import 'package:flutter/material.dart';
import '../../../core/domain/models.dart';

/// Immutable state that accumulates all selections across the booking flow.
class BookingState {
  final List<Pet> selectedPets;
  final ServiceType? selectedService;
  final ServiceAddress? serviceAddress;
  final Vet? selectedVet;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const BookingState({
    this.selectedPets = const [],
    this.selectedService,
    this.serviceAddress,
    this.selectedVet,
    this.selectedDate,
    this.selectedTime,
  });

  int get totalDurationMinutes => selectedPets.length * 30;

  String get durationLabel {
    final hours = totalDurationMinutes ~/ 60;
    final minutes = totalDurationMinutes % 60;
    if (hours > 0 && minutes > 0) return '$hours hora${hours > 1 ? 's' : ''} $minutes min';
    if (hours > 0) return '$hours hora${hours > 1 ? 's' : ''}';
    return '$minutes min';
  }

  String get serviceLabel =>
      selectedService == ServiceType.vaccination ? 'Vacunación Anual' : 'Desparasitación';

  TimeOfDay? get endTime {
    if (selectedTime == null) return null;
    final totalMinutes = selectedTime!.hour * 60 + selectedTime!.minute + totalDurationMinutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  BookingState copyWith({
    List<Pet>? selectedPets,
    ServiceType? selectedService,
    ServiceAddress? serviceAddress,
    Vet? selectedVet,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    bool clearSelectedTime = false,
  }) =>
      BookingState(
        selectedPets: selectedPets ?? this.selectedPets,
        selectedService: selectedService ?? this.selectedService,
        serviceAddress: serviceAddress ?? this.serviceAddress,
        selectedVet: selectedVet ?? this.selectedVet,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedTime: clearSelectedTime ? null : (selectedTime ?? this.selectedTime),
      );
}
