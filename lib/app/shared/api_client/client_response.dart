class ClientResponse {
  final dynamic data;
  final int statusCode;
  final String statusMessage;

  ClientResponse({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
  });
}
