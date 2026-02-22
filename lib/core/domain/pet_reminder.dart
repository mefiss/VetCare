import 'pet.dart';

class PetReminder {
  final Pet pet;
  final String message;
  final bool isOverdue;

  const PetReminder({
    required this.pet,
    required this.message,
    required this.isOverdue,
  });
}
