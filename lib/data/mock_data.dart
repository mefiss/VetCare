import 'package:flutter/material.dart';
import '../core/domain/models.dart';

// Re-export models so existing imports keep working.
export '../core/domain/models.dart';

// ── Mock Data ──────────────────────────────────────────

abstract final class MockData {
  static const ownerName = 'Diego';

  static const pets = [
    Pet(
      id: '1',
      name: 'Max',
      species: Species.dog,
      breed: 'Golden Retriever',
      nextVaccineDue: '5 días',
      nextDewormingDue: 'Hoy',
    ),
    Pet(
      id: '2',
      name: 'Luna',
      species: Species.cat,
      breed: 'Persa',
      nextVaccineDue: '3 días',
    ),
    Pet(
      id: '3',
      name: 'Rocky',
      species: Species.dog,
      breed: 'Labrador',
    ),
  ];

  static final reminders = [
    PetReminder(pet: pets[1], message: 'Vacuna en 3 días', isOverdue: false),
    PetReminder(pet: pets[0], message: 'Desparasitar hoy', isOverdue: true),
  ];

  static final upcomingAppointments = [
    Appointment(
      id: '1',
      petName: 'Luna',
      petSpecies: Species.cat,
      serviceType: ServiceType.vaccination,
      vetName: 'Dr. Juan Pérez',
      scheduledDate: DateTime(2026, 2, 15),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 14, minute: 30),
      status: AppointmentStatus.confirmed,
    ),
  ];

  static const vets = [
    Vet(
      id: '1',
      name: 'Dr. Juan Pérez',
      rating: 4.8,
      totalReviews: 24,
      coverageMunicipalities: ['Sabaneta', 'Envigado'],
      bio: 'Veterinario con 10+ años de experiencia en medicina preventiva y atención a domicilio. Especializado en el cuidado integral de mascotas.',
      specialties: ['Perros', 'Gatos', 'Aves'],
      phone: '+57 300 123 4567',
      reviews: [
        Review(
          id: '1',
          authorName: 'Ana M.',
          rating: 5,
          comment: '¡Excelente atención!',
          timeAgo: 'hace 1 semana',
        ),
        Review(
          id: '2',
          authorName: 'Carlos R.',
          rating: 5,
          comment: 'Muy puntual y profesional',
          timeAgo: 'hace 2 semanas',
        ),
      ],
      availableSlots: [
        TimeOfDay(hour: 9, minute: 0),
        TimeOfDay(hour: 9, minute: 30),
        TimeOfDay(hour: 10, minute: 0),
        TimeOfDay(hour: 10, minute: 30),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 14, minute: 30),
        TimeOfDay(hour: 15, minute: 0),
        TimeOfDay(hour: 15, minute: 30),
        TimeOfDay(hour: 16, minute: 0),
        TimeOfDay(hour: 16, minute: 30),
        TimeOfDay(hour: 17, minute: 0),
      ],
      nextAvailable: 'Hoy 2:00 PM',
    ),
    Vet(
      id: '2',
      name: 'Dra. María López',
      rating: 5.0,
      totalReviews: 12,
      coverageMunicipalities: ['Sabaneta'],
      bio: 'Médica veterinaria especializada en pequeños animales. Apasionada por la medicina preventiva y el bienestar animal.',
      specialties: ['Perros', 'Gatos'],
      phone: '+57 300 987 6543',
      reviews: [
        Review(
          id: '3',
          authorName: 'Laura P.',
          rating: 5,
          comment: 'Súper amable y cuidadosa',
          timeAgo: 'hace 3 días',
        ),
      ],
      availableSlots: [
        TimeOfDay(hour: 10, minute: 0),
        TimeOfDay(hour: 10, minute: 30),
        TimeOfDay(hour: 11, minute: 0),
        TimeOfDay(hour: 11, minute: 30),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 14, minute: 30),
        TimeOfDay(hour: 15, minute: 0),
      ],
      nextAvailable: 'Mañana 10:00 AM',
    ),
  ];

  static const municipalities = [
    'Medellín',
    'Envigado',
    'Sabaneta',
    'Itagüí',
    'Bello',
    'Copacabana',
    'La Estrella',
    'Caldas',
  ];
}
