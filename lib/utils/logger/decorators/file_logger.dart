import 'dart:io';

import 'package:bomberman/utils/logger.dart';
import 'package:bomberman/utils/logger/logger_decorator.dart';
import 'package:path_provider/path_provider.dart';

class FileLogger extends LoggerDecorator {
  final String _fileName;

  FileLogger(super.logger, {String fileName = 'app.log'})
      : _fileName = fileName;

  @override
  void log(String message, {LogType type = LogType.debug}) {
    super.log(message, type: type);
    _writeToFile('${type.name.toUpperCase()}: $message');
  }

  Future<void> _writeToFile(String text) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      await file.writeAsString('$text\n', mode: FileMode.append);
    } catch (e) {
      // Silently fail to avoid infinite error logging
      print('Failed to write to log file: $e');
    }
  }
}
