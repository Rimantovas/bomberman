import 'package:bomberman/utils/logger.dart';
import 'package:bomberman/utils/logger/base_logger.dart';

//* [PATTERN] Decorator Pattern
abstract class LoggerDecorator implements BaseLogger {
  final BaseLogger logger;

  LoggerDecorator(this.logger);

  @override
  void log(String message, {LogType type = LogType.debug}) {
    logger.log(message, type: type);
  }
}
