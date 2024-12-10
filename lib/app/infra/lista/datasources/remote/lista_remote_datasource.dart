import 'dart:convert';

import 'package:rt_flash/app/infra/lista/models/finalizar_hawb_model.dart';

import '../../../../shared/api_client/api_endpoints.dart';
import '../../../../shared/api_client/i_api_client.dart';
import '../../models/lista_model.dart';

abstract interface class IListaRemoteDatasource {
  Future<ListaModel> getLista({required String listaId});

  Future<void> finalizarHawbs({required List<FinalizarHawbModel> hawbs});
}

final class ListaRemoteDatasource implements IListaRemoteDatasource {
  final IApiClient _apiClient;

  ListaRemoteDatasource({required IApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ListaModel> getLista({required String listaId}) async {
    try {
      final result = await _apiClient.get(
          endpoint:
              ApiEndpoint.buscarLista.url); //TODO: DATASOURCE PARA IMPLEMENTAR
      return ListaModel.fromMap(json.decode(result.data));

      // return ListaModel.fromMap(json.decode(mockReturnLista));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> finalizarHawbs({required List<FinalizarHawbModel> hawbs}) async {
    try {
      await _apiClient.post(
        endpoint: ApiEndpoint.finalizarHawb.url,
        body: {
          "imei": "123", //TODO: DATASOURCE PARA IMPLEMENTAR
          "entregas": hawbs.map((e) => e.toMap()).toList(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
