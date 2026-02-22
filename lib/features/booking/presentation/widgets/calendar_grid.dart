import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom calendar grid for date selection in the booking flow.
class CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarGrid({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.today,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  static const _dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  static const _monthNames = [
    '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    // Monday = 1, Sunday = 7 → offset for grid
    final startWeekday = (firstDay.weekday - 1) % 7;
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;

    return Column(
      children: [
        // Month navigation header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPreviousMonth,
              icon: const Icon(Icons.chevron_left, color: AppColors.primary),
            ),
            Text(
              '${_monthNames[focusedMonth.month]} ${focusedMonth.year}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            IconButton(
              onPressed: onNextMonth,
              icon: const Icon(Icons.chevron_right, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Day labels
        Row(
          children: _dayLabels
              .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Date cells
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Empty cells before first day
            for (var i = 0; i < startWeekday; i++) const SizedBox.shrink(),
            // Day cells
            for (var day = 1; day <= daysInMonth; day++)
              _DateCell(
                day: day,
                isSelected: selectedDate != null &&
                    selectedDate!.year == focusedMonth.year &&
                    selectedDate!.month == focusedMonth.month &&
                    selectedDate!.day == day,
                isToday: today.year == focusedMonth.year &&
                    today.month == focusedMonth.month &&
                    today.day == day,
                isPast: DateTime(focusedMonth.year, focusedMonth.month, day)
                    .isBefore(DateTime(today.year, today.month, today.day)),
                onTap: () => onDateSelected(
                  DateTime(focusedMonth.year, focusedMonth.month, day),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DateCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final bool isPast;
  final VoidCallback onTap;

  const _DateCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isPast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isPast && !isToday;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.selectedBg
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected || isToday ? FontWeight.w600 : null,
              color: isSelected
                  ? Colors.white
                  : isDisabled
                      ? AppColors.border
                      : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
