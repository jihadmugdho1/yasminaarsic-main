import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Custom LogOutput that chunks long lines (>800 chars) using debugPrint
/// to prevent Android Logcat from truncating long strings (JWTs, JSON, etc.)
class SafeConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      if (line.length <= 800) {
        debugPrint(line);
      } else {
        var start = 0;
        while (start < line.length) {
          final end = (start + 800 < line.length) ? start + 800 : line.length;
          debugPrint(line.substring(start, end));
          start = end;
        }
      }
    }
  }
}

class AppLoggerHelper {
  AppLoggerHelper._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
    output: SafeConsoleOutput(),
    level: Level.debug,
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
}

