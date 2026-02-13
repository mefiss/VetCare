import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Grid of selectable 30-minute time slots, grouped by morning/afternoon.
class TimeSlotGrid extends StatelessWidget {
  final List<TimeOfDay> slots;
  final TimeOfDay? selectedSlot;
  final ValueChanged<TimeOfDay> onSlotSelected;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  String _formatSlot(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${t.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final morning = slots.where((s) => s.hour < 12).toList();
    final afternoon = slots.where((s) => s.hour >= 12).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morning.isNotEmpty) ...[
          const Text(
            'Mañana:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _buildGrid(morning),
          const SizedBox(height: 20),
        ],
        if (afternoon.isNotEmpty) ...[
          const Text(
            'Tarde:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _buildGrid(afternoon),
        ],
      ],
    );
  }

  Widget _buildGrid(List<TimeOfDay> items) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((slot) {
          final isSelected = selectedSlot != null &&
              selectedSlot!.hour == slot.hour &&
              selectedSlot!.minute == slot.minute;

          return GestureDetector(
            onTap: () => onSlotSelected(slot),
            child: Container(
              width: 95,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _formatSlot(slot),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
}
