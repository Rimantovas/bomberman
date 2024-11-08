import 'package:bomberman/utils/logger.dart';
import 'package:bomberman/utils/logger/logger_decorator.dart';
import 'package:dio/dio.dart';

class CrashLogger extends LoggerDecorator {
  final Dio _dio;
  final String _crashEndpoint;

  CrashLogger(
    super.logger, {
    required String crashEndpoint,
    Dio? dio,
  })  : _crashEndpoint = crashEndpoint,
        _dio = dio ?? Dio();

  @override
  void log(String message, {LogType type = LogType.debug}) {
    super.log(message, type: type);

    if (type == LogType.error) {
      _sendCrashReport(message);
    }
  }

  Future<void> _sendCrashReport(String errorMessage) async {
    try {
      await _dio.post(_crashEndpoint, data: {
        'error': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail to avoid infinite error logging
      print('Failed to send crash report: $e');
    }
  }
}
