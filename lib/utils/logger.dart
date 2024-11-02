import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LogType {
  debug,
  warning,
  error,
}

//* [PATTERN] Singleton Pattern
class Log {
  // make it thread safe
  static final Log _instance = Log._();
  final Logger _logger;

  Log._() : _logger = Logger(printer: PrettyPrinter());

  static Log get instance {
    return _instance;
  }

  void log(dynamic message, {LogType logType = LogType.debug}) {
    if (!kReleaseMode) {
      switch (logType) {
        case LogType.debug:
          _logger.d(message.toString());
        case LogType.warning:
          _logger.w(message.toString());
        case LogType.error:
          _logger.e(message.toString());
      }
    }
  }
}
