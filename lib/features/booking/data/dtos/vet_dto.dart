import 'package:json_annotation/json_annotation.dart';

part 'vet_dto.g.dart';

/// Maps GET /api/booking/veterinarians and /{id} response.
@JsonSerializable(createToJson: false)
class VetDto {
  final String id;
  final String name;
  final double rating;
  final int totalReviews;
  final List<String> coverageMunicipalities;
  final String? bio;
  final List<String>? specialties;
  final String? phone;
  final List<ReviewDto>? reviews;
  final String? nextAvailable;

  const VetDto({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalReviews,
    required this.coverageMunicipalities,
    this.bio,
    this.specialties,
    this.phone,
    this.reviews,
    this.nextAvailable,
  });

  factory VetDto.fromJson(Map<String, dynamic> json) =>
      _$VetDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ReviewDto {
  final String id;
  final String authorName;
  final int rating;
  final String? comment;
  final String timeAgo;

  const ReviewDto({
    required this.id,
    required this.authorName,
    required this.rating,
    this.comment,
    required this.timeAgo,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);
}
