import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/coleta/datasources/local/coleta_local_datasource.dart';

import '../../../../infra/coleta/models/coleta.dart';

part 'coleta_from_storage_state.dart';

class ColetaFromStorageCubit extends Cubit<ColetaFromStorageState> {
  final IColetaLocalDatasource _coletaLocalDatasource;

  ColetaFromStorageCubit({
    required IColetaLocalDatasource coletaLocalDatasource,
  })  : _coletaLocalDatasource = coletaLocalDatasource,
        super(ColetaFromStorageInitial());

  Future<void> resetColeta() async {
    try {
      await _coletaLocalDatasource.reset();

      emit(ColetaFromStorageInitial());
    } catch (e) {
      log('erro');
    }
  }

  Future<void> getColetaFromStorage() async {
    try {
      emit(ColetaFromStorageLoading());
      await _coletaLocalDatasource.getcoleta().then(
        (coletas) {
          emit(ColetaFromStorageSuccess(coletas: coletas));
        },
      );
    } catch (e) {
      emit(const ColetaFromStorageError(message: 'Erro'));
    }
  }
}
