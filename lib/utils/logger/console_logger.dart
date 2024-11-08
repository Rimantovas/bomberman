import 'package:bomberman/utils/logger.dart';
import 'package:bomberman/utils/logger/base_logger.dart';
import 'package:logger/logger.dart' as l;

class ConsoleLogger implements BaseLogger {
  final l.Logger _logger;

  ConsoleLogger() : _logger = l.Logger(printer: l.PrettyPrinter());

  @override
  void log(String message, {LogType type = LogType.debug}) {
    switch (type) {
      case LogType.debug:
        _logger.d(message);
      case LogType.warning:
        _logger.w(message);
      case LogType.error:
        _logger.e(message);
    }
  }
}
