import 'package:json_annotation/json_annotation.dart';

part 'slot_dto.g.dart';

/// Maps GET /api/booking/veterinarians/{vetId}/slots response.
@JsonSerializable(createToJson: false)
class SlotDto {
  final String date;
  final List<TimeSlotDto> availableSlots;

  const SlotDto({
    required this.date,
    required this.availableSlots,
  });

  factory SlotDto.fromJson(Map<String, dynamic> json) =>
      _$SlotDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class TimeSlotDto {
  final String startTime;
  final String endTime;

  const TimeSlotDto({
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlotDto.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotDtoFromJson(json);
}
