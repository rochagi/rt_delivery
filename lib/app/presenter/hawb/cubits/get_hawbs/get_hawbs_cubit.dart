import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/lista/datasources/local/lista_local_datasource.dart';

import '../../../../infra/lista/models/hawb_model.dart';

part 'get_hawbs_state.dart';

class GetHawbsCubit extends Cubit<GetHawbsState> {
  final IListaLocalDatasource _listaLocalDatasource;

  GetHawbsCubit({
    required IListaLocalDatasource listaLocalDatasource,
  })  : _listaLocalDatasource = listaLocalDatasource,
        super(GetHawbsInitial());

  Future<void> getHawbs() async {
    try {
      emit(GetHawbsLoading());
      final hawbs = await _listaLocalDatasource.gethawbs();
      emit(GetHawbsSuccess(hawbs));
    } catch (e) {
      emit(GetHawbsFailure(e.toString()));
    }
  }
}
