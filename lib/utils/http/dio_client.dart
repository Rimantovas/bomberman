import 'package:dio/dio.dart' as dio;

import 'http_client.dart';

class DioClient implements HttpClient {
  final dio.Dio _dio;

  DioClient({String? baseUrl})
      : _dio = dio.Dio(
          dio.BaseOptions(
            baseUrl: baseUrl ?? '',
            validateStatus: (status) => true,
          ),
        );

  @override
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      throw HttpError(message: e.toString());
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      throw HttpError(message: e.toString());
    }
  }

  @override
  Future<dynamic> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response.data;
    } catch (e) {
      throw HttpError(message: e.toString());
    }
  }

  @override
  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } catch (e) {
      throw HttpError(message: e.toString());
    }
  }

  @override
  void addInterceptor(HttpInterceptor interceptor) {
    _dio.interceptors.add(_DioInterceptorAdapter(interceptor));
  }
}

class _DioInterceptorAdapter extends dio.Interceptor {
  final HttpInterceptor interceptor;

  _DioInterceptorAdapter(this.interceptor);

  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    interceptor.onRequest(HttpRequest(
      path: options.path,
      headers: options.headers,
      data: options.data,
      queryParameters: options.queryParameters,
    ));
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    interceptor.onResponse(HttpResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      headers: response.headers.map,
    ));
    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    interceptor.onError(HttpError(
      message: err.message ?? 'Unknown error',
      statusCode: err.response?.statusCode,
      error: err,
    ));
    super.onError(err, handler);
  }
}
