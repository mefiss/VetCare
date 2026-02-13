// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotDto _$SlotDtoFromJson(Map<String, dynamic> json) => SlotDto(
      date: json['date'] as String,
      availableSlots: (json['availableSlots'] as List<dynamic>)
          .map((e) => TimeSlotDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

TimeSlotDto _$TimeSlotDtoFromJson(Map<String, dynamic> json) => TimeSlotDto(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
