import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../providers/booking_provider.dart';
import '../providers/vet_search_provider.dart';
import '../widgets/vet_card.dart';

/// Screen 5: List of available veterinarians filtered by municipality.
class VetListScreen extends ConsumerWidget {
  const VetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final municipality = booking.serviceAddress?.municipality ?? '';
    final serviceLabel = booking.selectedService == ServiceType.vaccination
        ? 'Vacunación'
        : 'Desparasitación';
    final petCount = booking.selectedPets.length;
    final vetsAsync = ref.watch(vetSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Veterinarios Disponibles'),
      ),
      body: Column(
        children: [
          // Fixed header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u{1F4CD} $municipality \u{2022} \u{1F489} $serviceLabel \u{2022} $petCount mascota${petCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: '\u{1F50D} Buscar por nombre...',
                    hintStyle:
                        const TextStyle(color: AppColors.textTertiary),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.border, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text('Fecha \u{25BC}'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text('Rating \u{25BC}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Scrollable vet list
          Expanded(
            child: AsyncValueWidget(
              value: vetsAsync,
              data: (vets) => vets.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay veterinarios disponibles\nen esta zona.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: vets.length,
                      itemBuilder: (context, index) => VetCard(
                        vet: vets[index],
                        isAvailableToday: index == 0,
                        onTap: () {
                          ref
                              .read(bookingProvider.notifier)
                              .setVet(vets[index]);
                          context.push('/booking/vet-profile');
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
