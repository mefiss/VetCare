/// App environment configuration.
/// Toggle [useMockData] to switch between real API and mock data.
abstract final class Environment {
  /// Set to false when the backend is deployed and ready.
  static const bool useMockData = true;

  /// API base URL.
  static const String baseUrl = 'https://api.petcare.app';
}
