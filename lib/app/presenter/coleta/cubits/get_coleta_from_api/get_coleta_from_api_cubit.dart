import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/coleta/datasources/local/coleta_local_datasource.dart';

import '../../../../infra/coleta/datasources/remote/coleta_remote_datasource.dart';

part 'get_coleta_from_api_state.dart';

class GetColetaFromApiCubit extends Cubit<GetColetaFromApiState> {
  final IColetaRemoteDatasource _getColetaRemoteDatasource;
  final IColetaLocalDatasource _coletaLocalDatasource;

  GetColetaFromApiCubit({
    required IColetaRemoteDatasource getColetaRemoteDatasource,
    required IColetaLocalDatasource coletaLocalDatasource,
  })  : _getColetaRemoteDatasource = getColetaRemoteDatasource,
        _coletaLocalDatasource = coletaLocalDatasource,
        super(GetColetaFromApiInitial());

  void resetState() {
    emit(GetColetaFromApiInitial());
  }

  Future<void> getColetaFromAPI({required String coletaId}) async {
    try {
      emit(GetColetaFromApiLoading());
      await _getColetaRemoteDatasource.getColeta(coletaId: coletaId).then(
        (coletaToSave) async {
          await _coletaLocalDatasource.saveColeta(coleta: coletaToSave).then(
            (value) {
              emit(GetColetaFromApiSuccess());
            },
          );
        },
      );
    } catch (e) {
      emit(const GetColetaFromApiError(message: 'Erro'));
    }
  }
}
