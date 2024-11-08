import 'package:flutter/foundation.dart';

import 'logger/base_logger.dart';
import 'logger/console_logger.dart';
import 'logger/decorators/alerts_logger.dart';
import 'logger/decorators/crash_logger.dart';
import 'logger/decorators/file_logger.dart';
import 'logger/logger_config.dart';

enum LogType {
  debug,
  warning,
  error,
}

//* [PATTERN] Singleton Pattern
class Log {
  static Log? _instance;
  final BaseLogger _logger;

  Log._({required LoggerConfig config}) : _logger = _createLogger(config);

  static BaseLogger _createLogger(LoggerConfig config) {
    // Start with base console logger
    BaseLogger logger = ConsoleLogger();

    // Add optional layers based on config
    if (config.enableCrashReporting) {
      if (config.crashEndpoint == null) {
        throw ArgumentError(
            'Crash endpoint must be provided when crash reporting is enabled');
      }
      logger = CrashLogger(
        logger,
        crashEndpoint: config.crashEndpoint!,
      );
    }

    if (config.enableFileLogging) {
      logger = FileLogger(
        logger,
        fileName: config.logFileName ?? 'app.log',
      );
    }

    if (config.enableAlerts) {
      if (config.alertsEndpoint == null) {
        throw ArgumentError(
            'Alerts endpoint must be provided when alerts are enabled');
      }
      logger = AlertsLogger(
        logger,
        alertsEndpoint: config.alertsEndpoint!,
      );
    }

    return logger;
  }

  static void initialize(LoggerConfig config) {
    _instance ??= Log._(config: config);
  }

  static Log get instance {
    if (_instance == null) {
      // Initialize with default configuration if not initialized
      initialize(const LoggerConfig());
    }
    return _instance!;
  }

  void log(dynamic message, {LogType logType = LogType.debug}) {
    if (!kReleaseMode) {
      _logger.log(message.toString(), type: logType);
    }
  }
}
