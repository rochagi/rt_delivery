import 'api_client_imports.dart';

abstract class IApiClient {
  Future<ClientResponse> get({
    required String endpoint,
    Map<String, dynamic> queryParams,
    Map<String, dynamic> headers,
  });
  Future<ClientResponse> post({
    required String endpoint,
    Map<String, dynamic> headers,
    Map<String, dynamic> body,
    Map<String, dynamic> queryParams,
  });
}
