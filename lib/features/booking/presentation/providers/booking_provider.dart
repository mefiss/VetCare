import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models.dart';
import '../../domain/booking_state.dart';

/// Notifier that manages the booking flow state across all 8 screens.
class BookingNotifier extends Notifier<BookingState> {
  @override
  BookingState build() => const BookingState();

  void togglePet(Pet pet) {
    final current = List<Pet>.from(state.selectedPets);
    final index = current.indexWhere((p) => p.id == pet.id);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(pet);
    }
    state = state.copyWith(selectedPets: current);
  }

  void setService(ServiceType service) =>
      state = state.copyWith(selectedService: service);

  void setAddress(ServiceAddress address) =>
      state = state.copyWith(serviceAddress: address);

  void setVet(Vet vet) => state = state.copyWith(selectedVet: vet);

  void setDate(DateTime date) =>
      state = state.copyWith(selectedDate: date, clearSelectedTime: true);

  void setTime(TimeOfDay time) => state = state.copyWith(selectedTime: time);

  void reset() => state = const BookingState();
}

final bookingProvider =
    NotifierProvider<BookingNotifier, BookingState>(BookingNotifier.new);
