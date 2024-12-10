import '../../../../shared/api_client/i_api_client.dart';
import '../../model/images.dart';

abstract interface class IImagesRemoteDatasource {
  Future<void> enviarImagens({required List<Images> images});
}

final class ImagesRemoteDatasource implements IImagesRemoteDatasource {
  final IApiClient _apiClient;

  ImagesRemoteDatasource({required IApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<void> enviarImagens({required List<Images> images}) async {
    try {
      //TODO IMPLEMENTAR DATASOURCE
    } catch (e) {
      rethrow;
    }
  }
}
