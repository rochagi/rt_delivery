import 'package:rt_flash/app/infra/coleta/models/finalizar_coleta.dart';

import '../../../../shared/api_client/api_endpoints.dart';
import '../../../../shared/api_client/i_api_client.dart';

abstract interface class IFinalizarColetaRemoteDatasource {
  Future<void> enviarColetasFinalizadas(
      {required List<FinalizarColeta> coletasFinalizadas});
}

final class FinalizarColetaRemoteDatasource
    implements IFinalizarColetaRemoteDatasource {
  final IApiClient _apiClient;

  FinalizarColetaRemoteDatasource({required IApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<void> enviarColetasFinalizadas(
      {required List<FinalizarColeta> coletasFinalizadas}) async {
    try {
      await _apiClient.post(
        endpoint: ApiEndpoint.finalizarColeta.url,
        body: {
          "imei": "123", //TODO: DATASOURCE PARA IMPLEMENTAR
          "entregas": coletasFinalizadas.map((e) => e.toMap()).toList(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
