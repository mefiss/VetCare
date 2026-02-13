import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../providers/booking_provider.dart';
import '../providers/pets_provider.dart';
import '../widgets/pet_selection_card.dart';

/// Screen 2: Select one or more pets for the appointment.
class SelectPetScreen extends ConsumerWidget {
  const SelectPetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPets = ref.watch(bookingProvider).selectedPets;
    final petsAsync = ref.watch(petsProvider);

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
            child: AsyncValueWidget(
              value: petsAsync,
              data: (pets) => ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    '¿Para quién es la cita?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...pets.map(
                    (pet) => PetSelectionCard(
                      pet: pet,
                      isSelected:
                          selectedPets.any((p) => p.id == pet.id),
                      onTap: () =>
                          ref.read(bookingProvider.notifier).togglePet(pet),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: '+ Agregar Nueva Mascota',
                    onPressed: () {},
                  ),
                ],
              ),
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
              onPressed: selectedPets.isEmpty
                  ? null
                  : () => context.push('/booking/select-service'),
            ),
          ),
        ],
      ),
    );
  }
}
