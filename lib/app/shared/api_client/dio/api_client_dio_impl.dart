import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rt_flash/app/infra/session/model/session_model.dart';
import 'package:rt_flash/app/shared/api_client/api_client_imports.dart';
import 'package:rt_flash/app/shared/preferences/preferences.dart';

final class ApiClientDioImpl implements IApiClient {
  final Dio dio;
  final IPreferences _preferences;

  ApiClientDioImpl({
    required this.dio,
    required IPreferences preferences,
  }) : _preferences = preferences {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.contains(ApiEndpoint.auth.url)) {
          final session = SessionModel.fromJson(await _preferences.get(
              key: PrefencesKeyEnum.session, type: PreferencesType.string));

          options.headers['Authorization'] =
              'login: ${session.login}, password: ${session.password}'; //TODO:MUDAR PRO FORMATO CORRETO
          options.copyWith(
            baseUrl: session.host,
          );
        }
        handler.next(options);
      },
    ));
  }

  @override
  Future<ClientResponse> get({
    required String endpoint,
    Map<String, dynamic> queryParams = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    try {
      final response = await dio.get(endpoint,
          queryParameters: queryParams,
          options: Options(
            headers: headers,
          ));
      log(response.data.toString());
      log(response.statusCode.toString());

      return ClientResponse(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        statusMessage: response.statusMessage ?? '',
      );
    } on DioException catch (e) {
      log('Dio error');

      throw e.error as Exception;
    } catch (e) {
      log('Erro no catch do Client');
      rethrow;
    }
  }

  @override
  Future<ClientResponse> post({
    required String endpoint,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParams = const {},
  }) async {
    try {
      log(json.encode(body));
      final response = await dio.post(
        endpoint,
        data: json.encode(body),
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );

      return ClientResponse(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        statusMessage: response.statusMessage ?? '',
      );
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
