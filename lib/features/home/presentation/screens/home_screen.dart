import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../registration/presentation/providers/registration_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/reminder_section.dart';
import '../widgets/upcoming_appointments_section.dart';

/// Main home screen with greeting, pets summary, reminders, and appointments.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Build real reminders from registered pets' vaccine/deworming dates.
  List<PetReminder> _buildReminders(List<Pet> pets) {
    final now = DateTime.now();
    final reminders = <PetReminder>[];

    for (final pet in pets) {
      if (pet.nextVaccineDate != null) {
        final diff = pet.nextVaccineDate!.difference(now).inDays;
        if (diff <= 30) {
          final isOverdue = diff < 0;
          reminders.add(PetReminder(
            pet: pet,
            message: isOverdue
                ? 'Vacuna vencida hace ${-diff} ${-diff == 1 ? 'día' : 'días'}'
                : diff == 0
                    ? 'Vacuna programada para hoy'
                    : 'Vacuna en $diff ${diff == 1 ? 'día' : 'días'}',
            isOverdue: isOverdue,
          ));
        }
      }
      if (pet.nextDewormingDate != null) {
        final diff = pet.nextDewormingDate!.difference(now).inDays;
        if (diff <= 30) {
          final isOverdue = diff < 0;
          reminders.add(PetReminder(
            pet: pet,
            message: isOverdue
                ? 'Desparasitación vencida hace ${-diff} ${-diff == 1 ? 'día' : 'días'}'
                : diff == 0
                    ? 'Desparasitación programada para hoy'
                    : 'Desparasitación en $diff ${diff == 1 ? 'día' : 'días'}',
            isOverdue: isOverdue,
          ));
        }
      }
    }

    // Sort: overdue first
    reminders.sort((a, b) {
      if (a.isOverdue && !b.isOverdue) return -1;
      if (!a.isOverdue && b.isOverdue) return 1;
      return 0;
    });

    return reminders;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final user = ref.watch(userProvider);
    final pets = ref.watch(registeredPetsProvider);
    final userName = user?.name.split(' ').first ?? 'Usuario';
    final realReminders = _buildReminders(pets);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AsyncValueWidget(
          value: dashboard,
          data: (data) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Hola $userName \u{1F44B}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Sección de mascotas del usuario
              _PetsSummarySection(pets: pets),
              const SizedBox(height: 20),

              if (realReminders.isNotEmpty) ...[
                ReminderSection(reminders: realReminders),
                const SizedBox(height: 20),
              ],
              UpcomingAppointmentsSection(
                appointments: data.appointments,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact section showing the user's registered pets on Home.
class _PetsSummarySection extends StatelessWidget {
  final List<Pet> pets;

  const _PetsSummarySection({required this.pets});

  @override
  Widget build(BuildContext context) {
    if (pets.isEmpty) {
      return SectionCard(
        child: Column(
          children: [
            const Text(
              'No tienes mascotas registradas',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.go('/pets'),
              child: const Text('Agregar mascota'),
            ),
          ],
        ),
      );
    }

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '\u{1F43E} Mis Mascotas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${pets.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...pets.map((pet) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => context.push('/pets/${pet.id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.selectedBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            pet.speciesEmoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              pet.breed,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: pet.species == Species.dog
                              ? AppColors.dogBadgeBg
                              : AppColors.catBadgeBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pet.species == Species.dog ? 'Perro' : 'Gato',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: pet.species == Species.dog
                                ? AppColors.dogBadgeText
                                : AppColors.catBadgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
