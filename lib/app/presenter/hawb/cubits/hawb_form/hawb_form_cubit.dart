import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/lista/models/hawb_model.dart';
import 'package:rt_flash/app/infra/lista/models/finalizar_hawb_model.dart';

import '../../../../infra/images/datasources/local/images_local_datasource.dart';
import '../../../../infra/images/model/images.dart';
import '../../../../infra/lista/datasources/local/lista_local_datasource.dart';
import '../../../../shared/utils/app_enums.dart';

part 'hawb_form_state.dart';

/*
  final String tipoDeOperacao;
  final String hawbReceiverType;
  final String hawbDevolutionReason;
  final String hawbReceiverName;
  final String hawbReceiverDocument;
  final String hawbARPhoto;
  final String hawbLocalPhoto;
  final String hawbSpecialPhoto;
  final String hawbSignature;
  final List<HawbFieldsEnum> formState.requiredFields;
  final List<HawbFieldsEnum> errorFields;
  final FormStateEnum formState;

*/

enum HawbFotoTypes { ar, local, especial, assinatura }

class HawbFormCubit extends Cubit<HawbFormState> {
  final IImagesLocalDatasource _imagesLocalDatasource;

  final IListaLocalDatasource _listaLocalDatasource;

  HawbFormCubit({
    required IListaLocalDatasource listaLocalDatasource,
    required IImagesLocalDatasource imagesLocalDatasource,
  })  : _listaLocalDatasource = listaLocalDatasource,
        _imagesLocalDatasource = imagesLocalDatasource,
        super(const HawbFormState());

  void resetState() {
    emit(const HawbFormState());
  }

  void atualizarTipoDeOperacao(String tipoDeOperacao) {
    emit(state.copyWith(tipoDeOperacao: tipoDeOperacao));
  }

  void atualizarTipoDeRecebedor(int? hawbReceiverType) {
    emit(state.copyWith(hawbReceiverType: hawbReceiverType));
  }

  void atualizarMotivoDevolucao(int? hawbDevolutionReason) {
    emit(state.copyWith(hawbDevolutionReason: hawbDevolutionReason));
  }

  void atualizarNomeRecebedor(String hawbReceiverName) {
    emit(state.copyWith(hawbReceiverName: hawbReceiverName));
  }

  void atualizarDocumentoRecebedor(String hawbReceiverDocument) {
    emit(state.copyWith(hawbReceiverDocument: hawbReceiverDocument));
  }

  void atualizarFotoAR(String hawbARPhoto) {
    emit(state.copyWith(hawbARPhoto: hawbARPhoto));
  }

  void atualizarFotoLocal(String hawbLocalPhoto) {
    emit(state.copyWith(hawbLocalPhoto: hawbLocalPhoto));
  }

  void atualizarFotoEspecial(String hawbSpecialPhoto) {
    emit(state.copyWith(hawbSpecialPhoto: hawbSpecialPhoto));
  }

  void atualizarFotoAssinatura(String hawbSignature) {
    emit(state.copyWith(hawbSignature: hawbSignature));
  }

  void atualizarRequiredFields(Set<HawbFieldsEnum> requiredFields) {
    emit(state.copyWith(requiredFields: requiredFields));
  }

  void atualizarErrorFields(Set<HawbFieldsEnum> errorFields) {
    emit(state.copyWith(errorFields: errorFields));
  }

  void atualizarFormState(FormStateEnum formState) {
    emit(state.copyWith(formState: formState));
  }

  Future<void> validadeHawbForm({required HawbModel hawb}) async {
    try {
      Set<HawbFieldsEnum> errorFields = {};

      final formState = state;

      if (formState.requiredFields.contains(HawbFieldsEnum.hawbReceiverType) &&
          state.hawbReceiverType == null) {
        errorFields.add(HawbFieldsEnum.hawbReceiverType);
      }
      if (formState.requiredFields
              .contains(HawbFieldsEnum.hawbDevolutionReason) &&
          state.hawbDevolutionReason == null) {
        errorFields.add(HawbFieldsEnum.hawbDevolutionReason);
      }
      if (formState.requiredFields.contains(HawbFieldsEnum.hawbReceiverName) &&
          state.hawbReceiverName.isEmpty) {
        errorFields.add(
          HawbFieldsEnum.hawbReceiverName,
        );
      }
      if (formState.requiredFields
              .contains(HawbFieldsEnum.hawbReceiverDocument) &&
          state.hawbReceiverDocument.isEmpty) {
        errorFields.add(HawbFieldsEnum.hawbReceiverDocument);
      }
      if (formState.requiredFields.contains(HawbFieldsEnum.hawbARPhoto) &&
          state.hawbARPhoto.isEmpty) {
        errorFields.add(HawbFieldsEnum.hawbARPhoto);
      }
      if (formState.requiredFields.contains(HawbFieldsEnum.hawbLocalPhoto) &&
          state.hawbLocalPhoto.isEmpty) {
        errorFields.add(HawbFieldsEnum.hawbLocalPhoto);
      }
      if (formState.requiredFields.contains(HawbFieldsEnum.hawbSpecialPhoto) &&
          state.hawbSpecialPhoto.isEmpty) {
        errorFields.add(HawbFieldsEnum.hawbSpecialPhoto);
      }

      errorFields.isEmpty
          ? submit(hawb: hawb)
          : emit(formState.copyWith(errorFields: errorFields));
    } catch (e) {
      log('Caiu no catch');
    }
  }

  void submit({required HawbModel hawb}) async {
    try {
      final formState = state;

      emit(state.copyWith(formState: FormStateEnum.loading));

      await _listaLocalDatasource.saveHawbFinish(
        hawbFinish: FinalizarHawbModel(
          codHawb: hawb.codHawb,
          dataHoraBaixa: DateTime.now().toIso8601String(),
          foto: formState.requiredFields.contains(HawbFieldsEnum.hawbARPhoto) ||
                  formState.requiredFields
                      .contains(HawbFieldsEnum.hawbLocalPhoto) ||
                  formState.requiredFields
                      .contains(HawbFieldsEnum.hawbSpecialPhoto)
              ? 1
              : 0,
          foraAlvo: 0,
          idGrauParentesco:
              formState.requiredFields.contains(HawbFieldsEnum.hawbReceiverType)
                  ? state.hawbReceiverType
                  : 0,
          idMotivo: formState.requiredFields
                  .contains(HawbFieldsEnum.hawbDevolutionReason)
              ? state.hawbDevolutionReason
              : 0,
          idSituacao: 0,
          idTipoDificuldade: 0,
          idTipoLocal: 0,
          latitude: 2,
          longitude: 3,
          nivelBateria: 100,
          nomeRecebedor:
              formState.requiredFields.contains(HawbFieldsEnum.hawbReceiverName)
                  ? formState.hawbReceiverName
                  : '',
          rG: formState.requiredFields
                  .contains(HawbFieldsEnum.hawbReceiverDocument)
              ? formState.hawbReceiverDocument
              : '',
          tipoBaixa: formState.requiredFields
                  .contains(HawbFieldsEnum.hawbDevolutionReason)
              ? 'DEVOLUCAO'
              : 'ENTREGA',
          xmlPesquisa: '',
        ),
      );
      final images = <Images>[
        if (formState.hawbARPhoto.isNotEmpty)
          Images(
            id: hawb.codHawb!,
            operationType: OperationType.hawb,
            imageType: formState.tipoDeOperacao,
            imagePath: formState.hawbARPhoto,
            imageName: HawbFotoTypes.ar.name.toUpperCase(),
          ),
        if (formState.hawbLocalPhoto.isNotEmpty)
          Images(
            id: hawb.codHawb!,
            operationType: OperationType.hawb,
            imageType: formState.tipoDeOperacao,
            imagePath: formState.hawbLocalPhoto,
            imageName: HawbFotoTypes.local.name.toUpperCase(),
          ),
        if (formState.hawbSpecialPhoto.isNotEmpty)
          Images(
            id: hawb.codHawb!,
            operationType: OperationType.hawb,
            imageType: formState.tipoDeOperacao,
            imagePath: formState.hawbSpecialPhoto,
            imageName: HawbFotoTypes.especial.name.toUpperCase(),
          ),
        if (formState.hawbSignature.isNotEmpty)
          Images(
            id: hawb.codHawb!,
            operationType: OperationType.hawb,
            imageType: formState.tipoDeOperacao,
            imagePath: formState.hawbSignature,
            imageName: HawbFotoTypes.assinatura.name.toUpperCase(),
          ),
      ];

      if (images.isNotEmpty) {
        await _imagesLocalDatasource.saveImages(images: images);
      }

      emit(state.copyWith(formState: FormStateEnum.success));
    } catch (e) {
      emit(state.copyWith(formState: FormStateEnum.error));
    }
  }
}
