import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/domain/models.dart';

/// Pet card with checkbox for multi-selection in the booking flow.
class PetSelectionCard extends StatelessWidget {
  final Pet pet;
  final bool isSelected;
  final VoidCallback onTap;

  const PetSelectionCard({
    super.key,
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  String? get _statusText {
    if (pet.nextVaccineDue != null) return 'Próxima vacuna: ${pet.nextVaccineDue}';
    if (pet.nextDewormingDue != null) return 'Desparasitar: ${pet.nextDewormingDue}';
    return null;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selectedBg : AppColors.background,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(pet.speciesEmoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      pet.breed,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_statusText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _statusText!,
                        style: TextStyle(
                          fontSize: 13,
                          color: pet.nextVaccineDue == null && pet.nextDewormingDue == null
                              ? AppColors.success
                              : AppColors.orangeAccent,
                        ),
                      ),
                    ],
                    if (_statusText == null)
                      const Text(
                        'Al día con vacunas',
                        style: TextStyle(fontSize: 13, color: AppColors.success),
                      ),
                  ],
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      );
}
