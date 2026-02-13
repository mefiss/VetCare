import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/domain/models.dart';
import '../providers/booking_provider.dart';
import '../widgets/service_option_card.dart';

/// Screen 3: Select the service type (vaccination or deworming).
class SelectServiceScreen extends ConsumerWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final petNames = booking.selectedPets.map((p) => p.name).join(', ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Agendar Cita'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Seleccionadas: $petNames',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '¿Qué servicio necesitas?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                ServiceOptionCard(
                  serviceType: ServiceType.vaccination,
                  isSelected:
                      booking.selectedService == ServiceType.vaccination,
                  onTap: () => ref
                      .read(bookingProvider.notifier)
                      .setService(ServiceType.vaccination),
                ),
                ServiceOptionCard(
                  serviceType: ServiceType.deworming,
                  isSelected:
                      booking.selectedService == ServiceType.deworming,
                  onTap: () => ref
                      .read(bookingProvider.notifier)
                      .setService(ServiceType.deworming),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: PrimaryButton(
              label: 'Continuar',
              onPressed: booking.selectedService == null
                  ? null
                  : () => context.push('/booking/address'),
            ),
          ),
        ],
      ),
    );
  }
}
