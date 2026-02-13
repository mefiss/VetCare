import 'package:json_annotation/json_annotation.dart';

part 'pet_dto.g.dart';

/// Maps GET /api/owner/pets response items.
@JsonSerializable(createToJson: false)
class PetDto {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String? nextVaccineDue;
  final String? nextDewormingDue;

  const PetDto({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    this.nextVaccineDue,
    this.nextDewormingDue,
  });

  factory PetDto.fromJson(Map<String, dynamic> json) =>
      _$PetDtoFromJson(json);
}
