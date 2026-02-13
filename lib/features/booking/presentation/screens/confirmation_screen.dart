import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_card.dart';
import '../providers/booking_provider.dart';

/// Screen 8: Appointment confirmation with full summary.
class ConfirmationScreen extends ConsumerWidget {
  const ConfirmationScreen({super.key});

  static const _monthNames = [
    '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  static const _dayNames = [
    '', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];

  String _formatDate(DateTime date) =>
      '${_dayNames[date.weekday]} ${date.day} de ${_monthNames[date.month]}';

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${t.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final vet = booking.selectedVet;
    final date = booking.selectedDate;
    final time = booking.selectedTime;
    final endTime = booking.endTime;
    final address = booking.serviceAddress;

    if (vet == null || date == null || time == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Success icon
                  const SizedBox(height: 40),
                  const Center(
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      '\u{00A1}Cita Confirmada!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Summary
                  SectionCard(
                    child: Column(
                      children: [
                        const Text(
                          'Tu cita ha sido agendada',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Date
                        _SummaryRow(
                          icon: '\u{1F4C5}',
                          text: _formatDate(date),
                        ),

                        // Time
                        _SummaryRow(
                          icon: '\u{1F552}',
                          text: '${_formatTime(time)} - ${endTime != null ? _formatTime(endTime) : ''}',
                        ),

                        // Vet
                        _SummaryRow(
                          icon: '\u{1F468}\u{200D}\u{2695}\u{FE0F}',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vet.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '\u{2B50} ${vet.rating} (${vet.totalReviews} reseñas)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              Text(
                                '\u{1F4DE} ${vet.phone}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Pets
                        ...booking.selectedPets.map(
                          (pet) => _SummaryRow(
                            icon: pet.speciesEmoji,
                            text: '${pet.name} - ${booking.serviceLabel}',
                          ),
                        ),

                        // Address
                        if (address != null)
                          _SummaryRow(
                            icon: '\u{1F4CD}',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.street,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  address.municipality,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reminder info
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Te enviaremos recordatorios:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '\u{2022} 1 día antes\n\u{2022} 1 hora antes',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  SecondaryButton(
                    label: '\u{1F4C5} Agregar a Mi Calendario',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: '\u{1F441}\u{FE0F} Ver Detalles de la Cita',
                    onPressed: () {},
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
                label: 'Listo',
                onPressed: () {
                  ref.read(bookingProvider.notifier).reset();
                  context.go('/home');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row in the confirmation summary with an emoji icon and text/widget.
class _SummaryRow extends StatelessWidget {
  final String icon;
  final String? text;
  final Widget? child;

  const _SummaryRow({required this.icon, this.text, this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: child ??
                  Text(
                    text ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
            ),
          ],
        ),
      );
}
