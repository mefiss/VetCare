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
  final String? address;
  final List<Review> reviews;
  final List<TimeOfDay> availableSlots;
  final String nextAvailable;

  const Vet({
    required this.id,
    required this.name,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.coverageMunicipalities = const [],
    this.bio = '',
    this.specialties = const [],
    this.phone = '',
    this.address,
    this.reviews = const [],
    this.availableSlots = const [],
    this.nextAvailable = '',
  });

  String get initials =>
      name.replaceAll('Dr. ', '').replaceAll('Dra. ', '').split(' ').map((w) => w[0]).take(2).join();
}
