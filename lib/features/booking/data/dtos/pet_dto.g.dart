// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetDto _$PetDtoFromJson(Map<String, dynamic> json) => PetDto(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      nextVaccineDue: json['nextVaccineDue'] as String?,
      nextDewormingDue: json['nextDewormingDue'] as String?,
    );
