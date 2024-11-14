import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_client.dart';

class HttpPackageClient implements HttpClient {
  final String? baseUrl;
  final List<HttpInterceptor> _interceptors = [];
  final http.Client adaptee;

  HttpPackageClient({this.baseUrl}) : adaptee = http.Client();

  String _buildUrl(String path) {
    return baseUrl != null ? '$baseUrl$path' : path;
  }

  @override
  Future<APIResponse<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri =
          Uri.parse(_buildUrl(path)).replace(queryParameters: queryParameters);
      var request = HttpRequest(path: path, queryParameters: queryParameters);
      request = _runRequestInterceptors(request);

      final response = await adaptee.get(uri, headers: request.headers);
      var httpResponse = _handleResponse(response);
      httpResponse = _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      var error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      error = _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<APIResponse<dynamic>> post(String path, {dynamic data}) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      var request = HttpRequest(path: path, data: data);
      request = _runRequestInterceptors(request);

      final response = await adaptee.post(
        uri,
        body: jsonEncode(request.data),
        headers: request.headers,
      );
      var httpResponse = _handleResponse(response);
      httpResponse = _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      var error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      error = _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<APIResponse<dynamic>> patch(String path, {dynamic data}) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      var request = HttpRequest(path: path, data: data);
      request = _runRequestInterceptors(request);
      final response = await adaptee.patch(
        uri,
        body: jsonEncode(request.data),
        headers: request.headers,
      );

      var httpResponse = _handleResponse(response);
      httpResponse = _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      var error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      error = _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<APIResponse<dynamic>> delete(String path) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      var request = HttpRequest(path: path);
      request = _runRequestInterceptors(request);

      final response = await adaptee.delete(uri, headers: request.headers);
      var httpResponse = _handleResponse(response);
      httpResponse = _runResponseInterceptors(httpResponse);

      return httpResponse;
    } catch (e) {
      var error = APIResponse(errorMessage: e.toString(), statusCode: 500);
      error = _runErrorInterceptors(error);
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

  HttpRequest _runRequestInterceptors(HttpRequest request) {
    var newRequest = request;
    for (final interceptor in _interceptors) {
      newRequest = interceptor.onRequest(newRequest);
    }
    return newRequest;
  }

  APIResponse<dynamic> _runResponseInterceptors(APIResponse<dynamic> response) {
    var newResponse = response;
    for (final interceptor in _interceptors) {
      newResponse = interceptor.onResponse(newResponse);
    }
    return newResponse;
  }

  APIResponse<dynamic> _runErrorInterceptors(APIResponse<dynamic> error) {
    var newError = error;
    for (final interceptor in _interceptors) {
      newError = interceptor.onError(newError);
    }
    return newError;
  }
}
