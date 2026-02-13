import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/domain/models.dart';

/// Service option card with radio button for the booking flow.
class ServiceOptionCard extends StatelessWidget {
  final ServiceType serviceType;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceOptionCard({
    super.key,
    required this.serviceType,
    required this.isSelected,
    required this.onTap,
  });

  String get _icon =>
      serviceType == ServiceType.vaccination ? '\u{1F489}' : '\u{1F48A}';

  String get _title =>
      serviceType == ServiceType.vaccination ? 'Vacunación Anual' : 'Desparasitación';

  String get _description => serviceType == ServiceType.vaccination
      ? 'Incluye: Rabia, Distemper, Parvovirus'
      : 'Tratamiento preventivo';

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selectedBg : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Radio button
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(_icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Text(
                    _title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  '$_description\nDuración: 30 min/mascota',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
