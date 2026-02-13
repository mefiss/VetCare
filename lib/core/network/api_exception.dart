/// Typed API exception wrapping the server error response.
class ApiException implements Exception {
  final String code;
  final String message;
  final List<Map<String, dynamic>> details;
  final int? statusCode;

  const ApiException({
    required this.code,
    required this.message,
    this.details = const [],
    this.statusCode,
  });

  factory ApiException.fromJson(Map<String, dynamic> json, [int? statusCode]) {
    final error = json['error'] as Map<String, dynamic>? ?? {};
    final rawDetails = error['details'] as List<dynamic>? ?? [];
    return ApiException(
      code: error['code'] as String? ?? 'UNKNOWN',
      message: error['message'] as String? ?? 'Error desconocido',
      details: rawDetails.cast<Map<String, dynamic>>(),
      statusCode: statusCode,
    );
  }

  @override
  String toString() => message;
}
