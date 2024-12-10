import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/lista/datasources/local/lista_local_datasource.dart';

import '../../../../infra/lista/datasources/remote/lista_remote_datasource.dart';
import '../../../../infra/lista/models/lista_model.dart';

part 'get_lista_state.dart';

class ListaCubit extends Cubit<GetListaState> {
  final IListaRemoteDatasource _getListaRemoteDatasource;
  final IListaLocalDatasource _listaLocalDatasource;

  ListaCubit({
    required IListaRemoteDatasource getListaRemoteDatasource,
    required IListaLocalDatasource listaLocalDatasource,
  })  : _getListaRemoteDatasource = getListaRemoteDatasource,
        _listaLocalDatasource = listaLocalDatasource,
        super(GetListaInitial());

  Future<void> getListaFromAPI({required String listaId}) async {
    try {
      emit(GetListaLoading());
      await _getListaRemoteDatasource.getLista(listaId: listaId).then(
        (listToSave) async {
          await _listaLocalDatasource.saveLista(lista: listToSave).then(
            (value) {
              emit(GetListaSuccess(lista: listToSave));
            },
          );
        },
      );
    } catch (e) {
      emit(const GetListaError(message: 'Erro'));
    }
  }

  Future<void> resetLista() async {
    try {
      await _listaLocalDatasource.reset();

      emit(GetListaInitial());
    } catch (e) {
      log('erro');
    }
  }

  Future<void> getListaFromStorage() async {
    try {
      emit(GetListaLoading());
      await _listaLocalDatasource.getlista().then(
        (lista) {
          if (lista != null) {
            emit(GetListaSuccess(lista: lista));
            return;
          }
          emit(GetListaInitial());
        },
      );
    } catch (e) {
      emit(const GetListaError(message: 'Erro'));
    }
  }
}
