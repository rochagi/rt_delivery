import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../utils/app_exceptions.dart';

class ApiDioInterception implements Interceptor {
  Connectivity connectivity = Connectivity();

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    late DioException? dioException;

    if (e.response?.statusCode == 400) {
      dioException = DioException(
          requestOptions: e.requestOptions,
          error: ApiDataException(
              message:
                  "${e.response?.data['message']} | statusCode: ${e.response?.statusCode}",
              stackTrace: StackTrace.current));
      handler.next(dioException);
      return;
    }
    if (e.response?.statusCode == 401) {
      dioException = DioException(
          requestOptions: e.requestOptions,
          error: ApiTokenException(
              message: "Token expirado | statusCode: ${e.response?.statusCode}",
              stackTrace: StackTrace.current));
      handler.next(dioException);
      return;
    }
    switch (e.type) {
      case DioExceptionType.connectionError:
        dioException = DioException(
            requestOptions: e.requestOptions,
            error: ApiConnectionException(
                message: "Sem conexão | statusCode: ${e.response?.statusCode}",
                stackTrace: StackTrace.current));
        break;
      case DioExceptionType.connectionTimeout:
        dioException = DioException(
            requestOptions: e.requestOptions,
            error: ApiConnectionException(
                message:
                    "Timeout na conexão | statusCode: ${e.response?.statusCode ?? 'N/A'}",
                stackTrace: StackTrace.current));
        break;
      case DioExceptionType.badResponse:
        dioException = DioException(
            requestOptions: e.requestOptions,
            error: ApiDataException(
                message: "Erro | statusCode: ${e.response?.statusCode}",
                stackTrace: StackTrace.current));
        break;
      default:
        dioException = DioException(
          requestOptions: e.requestOptions,
          error: ApiConnectionException(
            message: 'Erro',
            stackTrace: StackTrace.current,
          ),
        );
    }

    handler.next(dioException);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      handler.reject(DioException(
        type: DioExceptionType.connectionError,
        requestOptions: options,
        error: ApiConnectionException(
            message: 'Sem conexão com a internet',
            stackTrace: StackTrace.current),
      ));
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
