import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models.dart';
import '../../data/repositories/dashboard_repository.dart';

typedef DashboardData =
    ({List<PetReminder> reminders, List<Appointment> appointments});

final dashboardProvider = FutureProvider<DashboardData>((ref) {
  return ref.read(dashboardRepositoryProvider).getDashboard();
});
