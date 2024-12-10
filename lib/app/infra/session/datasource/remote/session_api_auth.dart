import 'package:rt_flash/app/infra/session/model/session_model.dart';
import 'package:rt_flash/app/shared/api_client/i_api_client.dart';

abstract interface class ISessionApiAuth {
  Future<void> auth(
      {required String host,
      required String identification,
      required String login,
      required String password});
}

final class SessionApiAuth implements ISessionApiAuth {
  final IApiClient _apiClient;

  SessionApiAuth({
    required IApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<void> auth(
      {required String host,
      required String identification,
      required String login,
      required String password}) async {
    try {
      await Future.delayed(
          const Duration(seconds: 2)); //TODO: DATASOURCE PARA IMPLEMENTAR
      return;
    } catch (e) {
      rethrow;
    }
  }
}
