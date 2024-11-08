import 'package:bomberman/utils/logger.dart';
import 'package:bomberman/utils/logger/logger_decorator.dart';
import 'package:dio/dio.dart';

class AlertsLogger extends LoggerDecorator {
  final Dio _dio;
  final String _alertsEndpoint;

  AlertsLogger(
    super.logger, {
    required String alertsEndpoint,
    Dio? dio,
  })  : _alertsEndpoint = alertsEndpoint,
        _dio = dio ?? Dio();

  @override
  void log(String message, {LogType type = LogType.debug}) {
    super.log(message, type: type);

    if (type == LogType.warning) {
      _sendAlert(message);
    }
  }

  Future<void> _sendAlert(String warningMessage) async {
    try {
      await _dio.post(_alertsEndpoint, data: {
        'warning': warningMessage,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail to avoid infinite error logging
      print('Failed to send alert: $e');
    }
  }
}
