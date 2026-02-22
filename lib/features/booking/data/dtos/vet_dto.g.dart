// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VetDto _$VetDtoFromJson(Map<String, dynamic> json) => VetDto(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      coverageMunicipalities: (json['coverageMunicipalities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      phone: json['phone'] as String?,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextAvailable: json['nextAvailable'] as String?,
    );

ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => ReviewDto(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      timeAgo: json['timeAgo'] as String,
    );
