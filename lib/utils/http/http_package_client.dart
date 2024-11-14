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
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri =
          Uri.parse(_buildUrl(path)).replace(queryParameters: queryParameters);
      final request = HttpRequest(path: path, queryParameters: queryParameters);
      _runRequestInterceptors(request);

      final response = await adaptee.get(uri);
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse.data;
    } catch (e) {
      final error = HttpError(message: e.toString());
      _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final request = HttpRequest(path: path, data: data);
      _runRequestInterceptors(request);

      final response = await adaptee.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse.data;
    } catch (e) {
      final error = HttpError(message: e.toString());
      _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<dynamic> patch(String path, {dynamic data}) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final request = HttpRequest(path: path, data: data);
      _runRequestInterceptors(request);

      final response = await adaptee.patch(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse.data;
    } catch (e) {
      final error = HttpError(message: e.toString());
      _runErrorInterceptors(error);
      throw error;
    }
  }

  @override
  Future<dynamic> delete(String path) async {
    try {
      final uri = Uri.parse(_buildUrl(path));
      final request = HttpRequest(path: path);
      _runRequestInterceptors(request);

      final response = await adaptee.delete(uri);
      final httpResponse = _handleResponse(response);
      _runResponseInterceptors(httpResponse);

      return httpResponse.data;
    } catch (e) {
      final error = HttpError(message: e.toString());
      _runErrorInterceptors(error);
      throw error;
    }
  }

  HttpResponse _handleResponse(http.Response response) {
    final dynamic data =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;
    return HttpResponse(
      data: data,
      statusCode: response.statusCode,
      headers: response.headers,
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

  void _runResponseInterceptors(HttpResponse response) {
    for (final interceptor in _interceptors) {
      interceptor.onResponse(response);
    }
  }

  void _runErrorInterceptors(HttpError error) {
    for (final interceptor in _interceptors) {
      interceptor.onError(error);
    }
  }
}
