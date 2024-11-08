class LoggerConfig {
  final bool enableFileLogging;
  final bool enableCrashReporting;
  final bool enableAlerts;
  final String? crashEndpoint;
  final String? alertsEndpoint;
  final String? logFileName;

  const LoggerConfig({
    this.enableFileLogging = false,
    this.enableCrashReporting = false,
    this.enableAlerts = false,
    this.crashEndpoint,
    this.alertsEndpoint,
    this.logFileName,
  });
}
