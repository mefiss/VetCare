class User {
  final String name;
  final String phone;
  final String address;
  final String municipality;
  final String? neighborhood;

  const User({
    required this.name,
    required this.phone,
    required this.address,
    required this.municipality,
    this.neighborhood,
  });
}
