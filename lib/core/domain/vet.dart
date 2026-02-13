import 'package:flutter/material.dart';
import 'review.dart';

class Vet {
  final String id;
  final String name;
  final double rating;
  final int totalReviews;
  final List<String> coverageMunicipalities;
  final String bio;
  final List<String> specialties;
  final String phone;
  final List<Review> reviews;
  final List<TimeOfDay> availableSlots;
  final String nextAvailable;

  const Vet({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalReviews,
    required this.coverageMunicipalities,
    required this.bio,
    required this.specialties,
    required this.phone,
    required this.reviews,
    required this.availableSlots,
    required this.nextAvailable,
  });

  String get initials =>
      name.replaceAll('Dr. ', '').replaceAll('Dra. ', '').split(' ').map((w) => w[0]).take(2).join();
}
