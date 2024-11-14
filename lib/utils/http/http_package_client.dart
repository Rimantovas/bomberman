import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_client.dart';

class HttpPackageClient implements HttpClient {
  final String? baseUrl;
  final List<HttpInterceptor> _interceptors = [];
  final http.Client _client;

  HttpPackageClient({this.baseUrl}) : _client = http.Client();

  String _buildUrl(String path) {
    return baseUrl != null ? '$baseUrl$path' : path;
  }

  @override
  Future<APIResponse<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri =
          Uri.parse(_buildUrl(path)).replace(queryParameters: queryParameters);
      final request = HttpRequest(path: path, queryParameters: queryParameters);
      _runRequestInterceptors(request);

      final response = await _client.get(uri);
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      final error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<APIResponse<dynamic>> post(String path, {dynamic data}) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final request = HttpRequest(path: path, data: data);
      _runRequestInterceptors(request);

      final response = await _client.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      final error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<APIResponse<dynamic>> patch(String path, {dynamic data}) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final request = HttpRequest(path: path, data: data);
      _runRequestInterceptors(request);

      final response = await _client.patch(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      final error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<APIResponse<dynamic>> delete(String path) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final request = HttpRequest(path: path);
      _runRequestInterceptors(request);

      final response = await _client.delete(uri);
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      final error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      _runErrorInterceptors(error);
      throw error;
    }
  }

  APIResponse<dynamic> _handleResponse(http.Response response) {
    final dynamic data =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;
    return APIResponse(
      data: data,
      statusCode: response.statusCode,
    );
  }

  @override
  void addInterceptor(HttpInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void _runRequestInterceptors(HttpRequest request) {
    for (final interceptor in _interceptors) {
      interceptor.onRequest(request);
    }
  }

  void _runResponseInterceptors(APIResponse<dynamic> response) {
    for (final interceptor in _interceptors) {
      interceptor.onResponse(response);
    }
  }

  void _runErrorInterceptors(APIResponse<dynamic> error) {
    for (final interceptor in _interceptors) {
      interceptor.onError(error);
    }
  }
}
