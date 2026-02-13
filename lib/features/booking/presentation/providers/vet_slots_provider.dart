import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/vet_repository.dart';
import 'booking_provider.dart';

/// Available time slots for the selected vet on the selected date.
final vetSlotsProvider = FutureProvider<List<TimeOfDay>>((ref) {
  final booking = ref.watch(bookingProvider);

  final vet = booking.selectedVet;
  final date = booking.selectedDate;
  final petCount = booking.selectedPets.length;

  if (vet == null || date == null) return Future.value([]);

  final durationMinutes = petCount * 30;
  final dateStr = DateFormat('yyyy-MM-dd').format(date);

  return ref.read(vetRepositoryProvider).getAvailableSlots(
        vetId: vet.id,
        date: dateStr,
        durationMinutes: durationMinutes,
      );
});
