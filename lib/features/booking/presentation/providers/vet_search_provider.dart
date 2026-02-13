import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/domain/models.dart';
import '../../data/repositories/vet_repository.dart';
import 'booking_provider.dart';

/// Searches vets based on the current booking state (municipality, service, date, petCount).
final vetSearchProvider = FutureProvider<List<Vet>>((ref) {
  final booking = ref.watch(bookingProvider);

  final municipality = booking.serviceAddress?.municipality;
  final service = booking.selectedService;
  final date = booking.selectedDate;
  final petCount = booking.selectedPets.length;

  if (municipality == null || service == null) return Future.value([]);

  final serviceStr = service == ServiceType.vaccination
      ? 'VACCINATION'
      : 'DEWORMING';
  final dateStr =
      date != null ? DateFormat('yyyy-MM-dd').format(date) : '';

  return ref.read(vetRepositoryProvider).searchVets(
        municipality: municipality,
        serviceType: serviceStr,
        date: dateStr,
        petCount: petCount,
      );
});
