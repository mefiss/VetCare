import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/domain/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../registration/presentation/providers/registration_provider.dart';

/// Screen showing full details for a single pet.
class PetDetailScreen extends ConsumerWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(registeredPetsProvider);
    final pet = pets.where((p) => p.id == petId).firstOrNull;

    if (pet == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Mascota no encontrada')),
      );
    }

    final now = DateTime.now();
    final vaccineOverdue = pet.nextVaccineDate != null &&
        pet.nextVaccineDate!.isBefore(now);
    final dewormingOverdue = pet.nextDewormingDate != null &&
        pet.nextDewormingDate!.isBefore(now);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => context.push('/pets/${pet.id}/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Pet avatar & basic info
          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.selectedBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      pet.speciesEmoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: pet.species == Species.dog
                        ? AppColors.dogBadgeBg
                        : AppColors.catBadgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pet.species == Species.dog ? 'Perro' : 'Gato',
                    style: TextStyle(
                      fontSize: 13,
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
          const SizedBox(height: 24),

          // Info card
          SectionCard(
            child: Column(
              children: [
                _InfoRow(
                  emoji: '\u{1F3F7}\uFE0F',
                  label: 'Raza',
                  value: pet.breed,
                ),
                if (pet.ageYears != null) ...[
                  const Divider(height: 20),
                  _InfoRow(
                    emoji: '\u{1F382}',
                    label: 'Edad',
                    value: '${pet.ageYears} ${pet.ageYears == 1 ? 'año' : 'años'}',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Health card
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\u{1FA7A} Salud',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _HealthRow(
                  emoji: '\u{1F489}',
                  label: 'Próxima vacuna',
                  date: pet.nextVaccineDate,
                  isOverdue: vaccineOverdue,
                ),
                const Divider(height: 24),
                _HealthRow(
                  emoji: '\u{1F48A}',
                  label: 'Próxima desparasitación',
                  date: pet.nextDewormingDate,
                  isOverdue: dewormingOverdue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action button
          if (vaccineOverdue || dewormingOverdue)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/booking/select-pet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Agendar cita',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _InfoRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );
}

class _HealthRow extends StatelessWidget {
  final String emoji;
  final String label;
  final DateTime? date;
  final bool isOverdue;

  const _HealthRow({
    required this.emoji,
    required this.label,
    required this.date,
    required this.isOverdue,
  });

  String _formatDate(DateTime d) {
    return DateFormat('dd/MM/yyyy').format(d);
  }

  String _daysLabel(DateTime d) {
    final diff = d.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Vencido hace ${-diff} ${-diff == 1 ? 'día' : 'días'}';
    if (diff == 0) return 'Hoy';
    return 'En $diff ${diff == 1 ? 'día' : 'días'}';
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _daysLabel(date!),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isOverdue ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            date != null ? _formatDate(date!) : 'Sin fecha',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: date != null
                  ? (isOverdue ? AppColors.error : AppColors.textPrimary)
                  : AppColors.textTertiary,
            ),
          ),
        ],
      );
}
