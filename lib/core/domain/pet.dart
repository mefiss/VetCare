import 'species.dart';

class Pet {
  final String id;
  final String name;
  final Species species;
  final String breed;
  final int? ageYears;
  final DateTime? nextVaccineDate;
  final DateTime? nextDewormingDate;

  /// Legacy string fields kept for mock data compatibility.
  final String? nextVaccineDue;
  final String? nextDewormingDue;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    this.ageYears,
    this.nextVaccineDate,
    this.nextDewormingDate,
    this.nextVaccineDue,
    this.nextDewormingDue,
  });

  String get speciesEmoji => species == Species.dog ? '\u{1F415}' : '\u{1F431}';

  Pet copyWith({
    String? name,
    Species? species,
    String? breed,
    int? ageYears,
    DateTime? nextVaccineDate,
    DateTime? nextDewormingDate,
    bool clearVaccineDate = false,
    bool clearDewormingDate = false,
  }) {
    return Pet(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      ageYears: ageYears ?? this.ageYears,
      nextVaccineDate: clearVaccineDate ? null : (nextVaccineDate ?? this.nextVaccineDate),
      nextDewormingDate: clearDewormingDate ? null : (nextDewormingDate ?? this.nextDewormingDate),
      nextVaccineDue: nextVaccineDue,
      nextDewormingDue: nextDewormingDue,
    );
  }
}
