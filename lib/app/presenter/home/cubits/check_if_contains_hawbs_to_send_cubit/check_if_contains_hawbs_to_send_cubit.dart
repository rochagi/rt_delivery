import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../infra/lista/datasources/local/lista_local_datasource.dart';

part 'check_if_contains_hawbs_to_send_state.dart';

class CheckIfContainsHawbsToSendCubit
    extends Cubit<CheckIfContainsHawbsToSendState> {
  final IListaLocalDatasource _listaLocalDatasource;

  CheckIfContainsHawbsToSendCubit(
      {required IListaLocalDatasource listaLocalDatasource})
      : _listaLocalDatasource = listaLocalDatasource,
        super(CheckIfContainsHawbsToSendInitial());

  Future<void> check() async {
    try {
      emit(CheckIfContainsHawbsToSendLoading());
      _listaLocalDatasource.getHawbsFinish().then(
        (value) {
          emit(CheckIfContainsHawbsToSendSuccess(
              containsHawbs: value.isNotEmpty));
        },
      );
    } catch (e) {
      emit(const CheckIfContainsHawbsToSendError(message: 'Erro'));
    }
  }
}
