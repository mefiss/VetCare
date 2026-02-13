import 'species.dart';

class Pet {
  final String id;
  final String name;
  final Species species;
  final String breed;
  final String? nextVaccineDue;
  final String? nextDewormingDue;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    this.nextVaccineDue,
    this.nextDewormingDue,
  });

  String get speciesEmoji => species == Species.dog ? '\u{1F415}' : '\u{1F431}';
}
