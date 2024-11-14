import 'package:dio/dio.dart' as dio;

import 'http_client.dart';

class DioClient implements HttpClient {
  final dio.Dio adaptee;

  DioClient({String? baseUrl})
      : adaptee = dio.Dio(
          dio.BaseOptions(
            baseUrl: baseUrl ?? '',
            validateStatus: (status) => true,
          ),
        );

  @override
  Future<APIResponse<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await adaptee.get(path, queryParameters: queryParameters);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<APIResponse<dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await adaptee.post(path, data: data);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<APIResponse<dynamic>> patch(String path, {dynamic data}) async {
    try {
      final response = await adaptee.patch(path, data: data);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<APIResponse<dynamic>> delete(String path) async {
    try {
      final response = await adaptee.delete(path);
      return APIResponse(data: response.data, statusCode: response.statusCode);
    } catch (e) {
      throw APIResponse(errorMessage: e.toString(), statusCode: 500);
    }
  }

  @override
  void addInterceptor(HttpInterceptor interceptor) {
    adaptee.interceptors.add(adapteeInterceptorAdapter(interceptor));
  }
}

class adapteeInterceptorAdapter extends dio.Interceptor {
  final HttpInterceptor interceptor;

  adapteeInterceptorAdapter(this.interceptor);

  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    interceptor.onRequest(HttpRequest(
      path: options.path,
      headers:
          options.headers.map((key, value) => MapEntry(key, value.toString())),
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
