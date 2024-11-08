import 'package:bomberman/utils/logger.dart';

abstract class BaseLogger {
  void log(String message, {LogType type = LogType.debug});
}
