import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_card.dart';
import '../../data/dtos/create_appointment_dto.dart';
import '../../data/repositories/appointment_repository.dart';
import '../providers/booking_provider.dart';
import '../providers/vet_slots_provider.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/time_slot_grid.dart';

/// Screen 7: Select date and time slot for the appointment.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;
  final _today = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(_today.year, _today.month);
  }

  Future<void> _confirmAppointment() async {
    final booking = ref.read(bookingProvider);
    setState(() => _isSubmitting = true);
    try {
      final dto = CreateAppointmentDto(
        petIds: booking.selectedPets.map((p) => p.id).toList(),
        serviceType: booking.selectedService!.name.toUpperCase(),
        veterinarianId: booking.selectedVet!.id,
        date: DateFormat('yyyy-MM-dd').format(booking.selectedDate!),
        startTime:
            '${booking.selectedTime!.hour.toString().padLeft(2, '0')}:${booking.selectedTime!.minute.toString().padLeft(2, '0')}',
        municipality: booking.serviceAddress!.municipality,
        address: booking.serviceAddress!.street,
        addressNotes: booking.serviceAddress!.additionalInstructions,
      );
      await ref.read(appointmentRepositoryProvider).createAppointment(dto);
      if (mounted) context.push('/booking/confirmation');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al confirmar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  static const _monthNames = [
    '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  static const _dayNames = [
    '', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];

  String _formatSelectedDate(DateTime date) =>
      '${_dayNames[date.weekday]} ${date.day} de ${_monthNames[date.month]}';

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider);
    final vet = booking.selectedVet;
    if (vet == null) return const SizedBox.shrink();

    final petNames = booking.selectedPets.map((p) => p.name).join(', ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Agendar con ${vet.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Context info
                Text(
                  'Servicio: ${booking.serviceLabel}\n'
                  'Mascotas: $petNames (${booking.durationLabel})',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Calendar
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona Fecha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CalendarGrid(
                        focusedMonth: _focusedMonth,
                        selectedDate: booking.selectedDate,
                        today: _today,
                        onDateSelected: (date) =>
                            ref.read(bookingProvider.notifier).setDate(date),
                        onPreviousMonth: () => setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month - 1,
                          );
                        }),
                        onNextMonth: () => setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month + 1,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Time slots (only visible when date is selected)
                if (booking.selectedDate != null) ...[
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Horarios Disponibles',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _formatSelectedDate(booking.selectedDate!),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 15),
                        AsyncValueWidget(
                          value: ref.watch(vetSlotsProvider),
                          data: (slots) => slots.isEmpty
                              ? const Text(
                                  'No hay horarios disponibles para esta fecha.',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                )
                              : TimeSlotGrid(
                                  slots: slots,
                                  selectedSlot: booking.selectedTime,
                                  onSlotSelected: (slot) => ref
                                      .read(bookingProvider.notifier)
                                      .setTime(slot),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Warning banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningBannerBg,
                      border: const Border(
                        left: BorderSide(
                          color: AppColors.warningBannerBorder,
                          width: 4,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\u{26A0}\u{FE0F} Tu cita durará ${booking.durationLabel} '
                      '(${booking.selectedPets.length} mascota${booking.selectedPets.length > 1 ? 's' : ''} \u{00D7} 30 min)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.warningBannerText,
                      ),
                    ),
                  ),
                ],
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
              label: _isSubmitting ? 'Confirmando...' : 'Confirmar Cita',
              onPressed: booking.selectedDate != null &&
                      booking.selectedTime != null &&
                      !_isSubmitting
                  ? _confirmAppointment
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
