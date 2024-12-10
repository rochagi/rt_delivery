import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/coleta/datasources/local/finalizar_coleta_local_datasource.dart';
import 'package:rt_flash/app/infra/images/datasources/local/images_local_datasource.dart';
import 'package:rt_flash/app/infra/images/datasources/remote/images_remote_datasource.dart';
import 'package:rt_flash/app/infra/lista/datasources/remote/lista_remote_datasource.dart';

import '../../../../infra/coleta/datasources/remote/finalizar_coleta_remote_datasource.dart';
import '../../../../infra/lista/datasources/local/lista_local_datasource.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final IListaLocalDatasource _listaLocalDatasource;
  final IListaRemoteDatasource _listaRemoteDatasource;
  final IFinalizarColetaLocalDatasource _finalizarColetaLocalDatasource;
  final IFinalizarColetaRemoteDatasource _finalizarColetaRemoteDatasource;
  final IImagesLocalDatasource _imagesLocalDatasource;
  final IImagesRemoteDatasource _imagesRemoteDatasource;
  SyncCubit({
    required IListaLocalDatasource listaLocalDatasource,
    required IListaRemoteDatasource listaRemoteDatasource,
    required IFinalizarColetaLocalDatasource finalizarColetaLocalDatasource,
    required IFinalizarColetaRemoteDatasource finalizarColetaRemoteDatasource,
    required IImagesLocalDatasource imagesLocalDatasource,
    required IImagesRemoteDatasource imagesRemoteDatasource,
  })  : _listaLocalDatasource = listaLocalDatasource,
        _listaRemoteDatasource = listaRemoteDatasource,
        _finalizarColetaLocalDatasource = finalizarColetaLocalDatasource,
        _finalizarColetaRemoteDatasource = finalizarColetaRemoteDatasource,
        _imagesLocalDatasource = imagesLocalDatasource,
        _imagesRemoteDatasource = imagesRemoteDatasource,
        super(const SyncInitial());

  void buscarItemsPendentes() async {
    try {
      final hawbsParaEnviar = await _listaLocalDatasource.getHawbsFinish();
      final coletasParaEnviar =
          await _finalizarColetaLocalDatasource.getColetasFinalizadas();
      emit(SyncInitial(
          itemsToSync: hawbsParaEnviar.length + coletasParaEnviar.length));
    } catch (e) {
      emit(const SyncInitial());
    }
  }

  void sync() async {
    try {
      emit(SyncLoading());
      final hawbsParaEnviar = await _listaLocalDatasource.getHawbsFinish();
      if (hawbsParaEnviar.isNotEmpty) {
        await _listaRemoteDatasource.finalizarHawbs(hawbs: hawbsParaEnviar);
        await _listaLocalDatasource.reset();
      }
      final coletasParaEnviar =
          await _finalizarColetaLocalDatasource.getColetasFinalizadas();
      if (coletasParaEnviar.isNotEmpty) {
        await _finalizarColetaRemoteDatasource.enviarColetasFinalizadas(
            coletasFinalizadas: coletasParaEnviar);
        await _finalizarColetaLocalDatasource.reset();
      }

      final imagensParaEnviar = await _imagesLocalDatasource.getimages();
      if (imagensParaEnviar.isNotEmpty) {
        await _imagesRemoteDatasource.enviarImagens(images: imagensParaEnviar);
        await _imagesLocalDatasource.reset();
      }

      emit(SyncSuccess());
    } catch (e) {
      //TODO: Tratar erro
      emit(const SyncError('Erro ao sincronizar'));
    }
  }

  void resetState() {
    emit(const SyncInitial());
  }

  void syncError() {
    emit(const SyncError('Erro ao sincronizar'));
  }
}
