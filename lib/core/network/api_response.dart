/// Generic wrapper matching the API response envelope:
/// `{ "data": {}, "message": "", "timestamp": "" }`
class ApiResponse<T> {
  final T data;
  final String message;
  final String timestamp;

  const ApiResponse({
    required this.data,
    required this.message,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJson,
  ) =>
      ApiResponse(
        data: fromJson(json['data']),
        message: json['message'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
      );
}
