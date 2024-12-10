import 'dart:convert';

import '../../../../shared/api_client/api_endpoints.dart';
import '../../../../shared/api_client/i_api_client.dart';
import '../../models/coleta.dart';

abstract interface class IColetaRemoteDatasource {
  Future<ColetaModel> getColeta({required String coletaId});
}

final class ColetaRemoteDatasource implements IColetaRemoteDatasource {
  final IApiClient _apiClient;

  ColetaRemoteDatasource({required IApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ColetaModel> getColeta({required String coletaId}) async {
    try {
      final result =
          await _apiClient.get(endpoint: ApiEndpoint.buscarColeta.url);

      //TODO: DATASOURCE PARA IMPLEMENTAR

      return ColetaModel.fromMap(json.decode(result.data));

      //return ColetaModel.fromMap(json.decode(mockReturnColeta));
    } catch (e) {
      rethrow;
    }
  }
}
