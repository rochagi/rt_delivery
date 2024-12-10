abstract class AppException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String? aditionalInfo;

  AppException(
      {required this.message, required this.stackTrace, this.aditionalInfo});
}

class ApiTokenException extends AppException {
  ApiTokenException(
      {required super.message, required super.stackTrace, super.aditionalInfo});
}

class ApiConnectionException extends AppException {
  ApiConnectionException(
      {required super.message, required super.stackTrace, super.aditionalInfo});
}


class ApiDataException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String? aditionalInfo;

  ApiDataException(
      {required this.message, required this.stackTrace, this.aditionalInfo});
}

class PreferencesException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String? aditionalInfo;

  PreferencesException(
      {required this.message, required this.stackTrace, this.aditionalInfo});
}

class DBException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String? aditionalInfo;

  DBException(
      {required this.message, required this.stackTrace, this.aditionalInfo});
}

class DataParserException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String? aditionalInfo;

  DataParserException(
      {required this.message, required this.stackTrace, this.aditionalInfo});
}

class UnknowException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final String? aditionalInfo;

  UnknowException(
      {required this.message, required this.stackTrace, this.aditionalInfo});
}
