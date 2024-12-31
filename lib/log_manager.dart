class LogManager {
  static final List<String> _logs = [];

  static void addLog(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _logs.add("[$timestamp] \n$message");
  }

  static List<String> get logs => List.unmodifiable(_logs);

  static void clearLogs() {
    _logs.clear();
  }
}
