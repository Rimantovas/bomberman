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
  Future<APIResponse<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<APIResponse<dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<APIResponse<dynamic>> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<APIResponse<dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
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
    interceptor.onResponse(APIResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
    ));
    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    interceptor.onError(APIResponse(
      errorMessage: err.message ?? 'Unknown error',
      statusCode: err.response?.statusCode,
    ));
    super.onError(err, handler);
  }
}
