//* [PATTERN] Adapter Pattern

abstract class HttpClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data});
  Future<dynamic> patch(String path, {dynamic data});
  Future<dynamic> delete(String path);

  void addInterceptor(HttpInterceptor interceptor);
}

abstract class HttpInterceptor {
  void onRequest(HttpRequest request);
  void onResponse(HttpResponse response);
  void onError(HttpError error);
}

class HttpRequest {
  final String path;
  final Map<String, dynamic> headers;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;

  HttpRequest({
    required this.path,
    this.headers = const {},
    this.data,
    this.queryParameters,
  });
}

class HttpResponse {
  final dynamic data;
  final int statusCode;
  final Map<String, dynamic> headers;

  HttpResponse({
    required this.data,
    required this.statusCode,
    this.headers = const {},
  });
}

class HttpError {
  final String message;
  final int? statusCode;
  final dynamic error;

  HttpError({
    required this.message,
    this.statusCode,
    this.error,
  });
}
