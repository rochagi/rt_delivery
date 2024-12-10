import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/coleta/datasources/local/coleta_local_datasource.dart';
import 'package:rt_flash/app/infra/coleta/models/finalizar_coleta.dart';
import 'package:rt_flash/app/infra/images/datasources/local/images_local_datasource.dart';

import '../../../../infra/coleta/datasources/local/finalizar_coleta_local_datasource.dart';
import '../../../../infra/coleta/models/coleta.dart';
import '../../../../infra/images/model/images.dart';
import '../../../../shared/utils/app_enums.dart';

part 'coleta_form_state.dart';

enum ColetaFotoTypes { produto, local, pedido, foraalvo }

class ColetaFormCubit extends Cubit<ColetaFormDefaultState> {
  final IImagesLocalDatasource _imagesLocalDatasource;
  final IFinalizarColetaLocalDatasource _finalizarColetaLocalDatasource;
  final IColetaLocalDatasource _coletaLocalDatasource;
  ColetaFormCubit({
    required IImagesLocalDatasource imagesLocalDatasource,
    required IFinalizarColetaLocalDatasource finalizarColetaLocalDatasource,
    required IColetaLocalDatasource coletaLocalDatasource,
  })  : _imagesLocalDatasource = imagesLocalDatasource,
        _finalizarColetaLocalDatasource = finalizarColetaLocalDatasource,
        _coletaLocalDatasource = coletaLocalDatasource,
        super(const ColetaFormDefaultState());

  void updateRequiredFields(List<ColetaFormFieldsEnum> requiredFields) {
    emit(state.copyWith(requiredFields: requiredFields));
  }

  void updateTipo(String tipo) {
    emit(state.copyWith(tipo: tipo));
  }

  void updateIdentificacao(String identificacao) {
    emit(state.copyWith(identificacao: identificacao));
  }

  void updateRg(String rg) {
    emit(state.copyWith(rg: rg));
  }

  void updateFotoProdutoColetado(String? fotoProdutoColetado) {
    emit(state.copyWith(fotoProdutoColetado: fotoProdutoColetado));
  }

  void updateFotoLocalColeta(String? fotoLocalColeta) {
    emit(state.copyWith(fotoLocalColeta: fotoLocalColeta));
  }

  void updateFotoPedidoColeta(String? fotoPedidoColeta) {
    emit(state.copyWith(fotoPedidoColeta: fotoPedidoColeta));
  }

  void updateFotoForaDoAlvo(String? fotoForaDoAlvo) {
    emit(state.copyWith(fotoForaDoAlvo: fotoForaDoAlvo));
  }

  void validate({required ColetaModel coleta}) {
    //  emit(ColetaFormSaveLoadingState());

    final errorFields = <ColetaFormFieldsEnum>[];

    final formState = state;

    if (formState.requiredFields
            .contains(ColetaFormFieldsEnum.fotoProdutoColetado) &&
        formState.fotoProdutoColetado.isEmpty) {
      errorFields.add(ColetaFormFieldsEnum.fotoProdutoColetado);
    }

    if (formState.requiredFields
            .contains(ColetaFormFieldsEnum.fotoLocalColeta) &&
        formState.fotoLocalColeta.isEmpty) {
      errorFields.add(ColetaFormFieldsEnum.fotoLocalColeta);
    }

    if (formState.requiredFields
            .contains(ColetaFormFieldsEnum.fotoPedidoColeta) &&
        formState.fotoPedidoColeta.isEmpty) {
      errorFields.add(ColetaFormFieldsEnum.fotoPedidoColeta);
    }

    if (formState.requiredFields
            .contains(ColetaFormFieldsEnum.fotoForaDoAlvo) &&
        formState.fotoForaDoAlvo.isEmpty) {
      errorFields.add(ColetaFormFieldsEnum.fotoForaDoAlvo);
    }
    errorFields.isEmpty
        ? submit(coleta: coleta)
        : emit(formState.copyWith(errorFields: errorFields));
  }

  void submit({required ColetaModel coleta}) async {
    try {
      final formState = state;

      emit(state.copyWith(formState: FormStateEnum.loading));
      await _finalizarColetaLocalDatasource.saveFinalizarColeta(
        coleta: FinalizarColeta(
          codColeta: coleta.coletaId!,
          clienteId: coleta.clienteId!,
          contratoId: coleta.contratoId!,
          dataProcesso: DateTime.now().toString(),
          tipoProcesso: state.tipo,
          latitude: 0.toString(), //TODO: Trocar por cordenadas reais
          longitude: 0.toString(), //TODO: Trocar por cordenadas reais
          foraAlvo: 0.toString(),
          nivelBateria: 0.toString(),
          recebedor: state.identificacao,
          rg: state.rg,
        ),
      );
      final images = <Images>[
        if (formState.fotoProdutoColetado.isNotEmpty)
          Images(
            id: coleta.coletaId!,
            operationType: OperationType.coleta,
            imageType: formState.tipo,
            imagePath: formState.fotoProdutoColetado,
            imageName: ColetaFotoTypes.produto.name.toUpperCase(),
          ),
        if (formState.fotoLocalColeta.isNotEmpty)
          Images(
            id: coleta.coletaId!,
            operationType: OperationType.coleta,
            imageType: formState.tipo,
            imagePath: formState.fotoLocalColeta,
            imageName: ColetaFotoTypes.local.name.toUpperCase(),
          ),
        if (formState.fotoPedidoColeta.isNotEmpty)
          Images(
            id: coleta.coletaId!,
            operationType: OperationType.coleta,
            imageType: formState.tipo,
            imagePath: formState.fotoPedidoColeta,
            imageName: ColetaFotoTypes.pedido.name.toUpperCase(),
          ),
        if (formState.fotoForaDoAlvo.isNotEmpty)
          Images(
            id: coleta.coletaId!,
            operationType: OperationType.coleta,
            imageType: formState.tipo,
            imagePath: formState.fotoForaDoAlvo,
            imageName: ColetaFotoTypes.foraalvo.name.toUpperCase(),
          ),
      ];

      if (images.isNotEmpty) {
        await _imagesLocalDatasource.saveImages(images: images);
      }

      await _coletaLocalDatasource.deleteColeta(coleta: coleta);
      emit(state.copyWith(formState: FormStateEnum.success));
    } catch (e) {
      emit(state.copyWith(formState: FormStateEnum.error));
    }
  }
}
