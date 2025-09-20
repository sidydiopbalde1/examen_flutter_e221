class ApiResponse<T> {
  final int statusCode;
  final String status;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.data,
    this.errors,
    this.meta,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isError => !isSuccess;

  factory ApiResponse.fromMap(Map<String, dynamic> map, [T? data]) {
    return ApiResponse<T>(
      statusCode: map['statusCode'] ?? 0,
      status: map['status'] ?? 'unknown',
      message: map['message'] ?? 'Aucun message',
      data: data ?? map['data'],
      errors: map['errors'],
      meta: map['meta'],
    );
  }
}