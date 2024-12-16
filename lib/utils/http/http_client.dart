//* [PATTERN] Adapter Pattern

import 'package:bomberman/utils/iterable_map.dart';

abstract class HttpClient {
  Future<APIResponse> get(String path, {Map<String, dynamic>? queryParameters});
  Future<APIResponse> post(String path, {dynamic data});
  Future<APIResponse> patch(String path, {dynamic data});
  Future<APIResponse> delete(String path);

  void addInterceptor(HttpInterceptor interceptor);
}

abstract class HttpInterceptor {
  HttpRequest onRequest(HttpRequest request);
  APIResponse onResponse(APIResponse response);
  APIResponse onError(APIResponse error);
}

class HttpRequest {
  final String path;
  final Map<String, String> headers;
  final MapIterator? data;
  final Map<String, dynamic>? queryParameters;

  HttpRequest({
    required this.path,
    this.headers = const {
      'Content-Type': 'application/json',
    },
    this.data,
    this.queryParameters,
  });
}

class APIResponse<T> {
  APIResponse({
    this.data,
    this.errorMessage,
    this.isError = false,
    this.statusCode,
  });
  T? data;
  bool isError;
  String? errorMessage;
  num? statusCode;

  @override
  String toString() {
    return 'APIResponse{data: $data, isError: $isError, errorMessage: $errorMessage, statusCode: $statusCode}';
  }
}
