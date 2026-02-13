import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/reminder_section.dart';
import '../widgets/upcoming_appointments_section.dart';

/// Main home screen with greeting, reminders, and upcoming appointments.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AsyncValueWidget(
          value: dashboard,
          data: (data) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Bienvenido Diego \u{1F44B}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 25),
              ReminderSection(reminders: data.reminders),
              const SizedBox(height: 20),
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
