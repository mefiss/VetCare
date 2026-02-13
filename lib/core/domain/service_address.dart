class ServiceAddress {
  final String municipality;
  final String street;
  final String? neighborhood;
  final String? additionalInstructions;

  const ServiceAddress({
    required this.municipality,
    required this.street,
    this.neighborhood,
    this.additionalInstructions,
  });
}
