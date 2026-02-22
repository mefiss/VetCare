import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/domain/models.dart';

/// Vet card shown in the vet list screen.
class VetCard extends StatelessWidget {
  final Vet vet;
  final bool isAvailableToday;
  final VoidCallback onTap;

  const VetCard({
    super.key,
    required this.vet,
    this.isAvailableToday = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + name + rating
              Row(
                children: [
                  _VetAvatar(initials: vet.initials),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vet.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Text('\u{2B50}',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${vet.rating} (${vet.totalReviews} reseñas)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Municipality
              Text(
                '\u{1F4CD} ${vet.coverageMunicipalities.join(', ')}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              // Availability
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isAvailableToday ? AppColors.success : AppColors.orangeStatus,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAvailableToday
                          ? '\u{2705} Disponible hoy'
                          : '\u{2705} Disponible mañana',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Próximo: ${vet.nextAvailable}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Ver Disponibilidad \u{2192}',
                padding: const EdgeInsets.symmetric(vertical: 10),
                onPressed: onTap,
              ),
            ],
          ),
        ),
      );
}

/// Circular avatar with vet initials and gradient background.
class _VetAvatar extends StatelessWidget {
  final String initials;
  final double size;

  const _VetAvatar({required this.initials, this.size = 50}); // ignore: unused_element_parameter

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
