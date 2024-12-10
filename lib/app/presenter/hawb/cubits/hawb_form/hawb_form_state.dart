part of 'hawb_form_cubit.dart';

final class HawbFormState extends Equatable {
  final String tipoDeOperacao;
  final int? hawbReceiverType;
  final int? hawbDevolutionReason;
  final String hawbReceiverName;
  final String hawbReceiverDocument;
  final String hawbARPhoto;
  final String hawbLocalPhoto;
  final String hawbSpecialPhoto;
  final String hawbSignature;
  final Set<HawbFieldsEnum> requiredFields;
  final Set<HawbFieldsEnum> errorFields;
  final FormStateEnum formState;

  const HawbFormState({
    this.tipoDeOperacao = '',
    this.hawbReceiverType,
    this.hawbDevolutionReason,
    this.hawbReceiverName = '',
    this.hawbReceiverDocument = '',
    this.hawbARPhoto = '',
    this.hawbLocalPhoto = '',
    this.hawbSpecialPhoto = '',
    this.hawbSignature = '',
    this.requiredFields = const {},
    this.errorFields = const {},
    this.formState = FormStateEnum.initial,
  });

  HawbFormState copyWith({
    String? tipoDeOperacao,
    int? hawbReceiverType,
    int? hawbDevolutionReason,
    String? hawbReceiverName,
    String? hawbReceiverDocument,
    String? hawbARPhoto,
    String? hawbLocalPhoto,
    String? hawbSpecialPhoto,
    String? hawbSignature,
    Set<HawbFieldsEnum>? requiredFields,
    Set<HawbFieldsEnum>? errorFields,
    FormStateEnum? formState,
  }) {
    return HawbFormState(
      tipoDeOperacao: tipoDeOperacao ?? this.tipoDeOperacao,
      hawbReceiverType: hawbReceiverType ?? this.hawbReceiverType,
      hawbDevolutionReason: hawbDevolutionReason ?? this.hawbDevolutionReason,
      hawbReceiverName: hawbReceiverName ?? this.hawbReceiverName,
      hawbReceiverDocument: hawbReceiverDocument ?? this.hawbReceiverDocument,
      hawbARPhoto: hawbARPhoto ?? this.hawbARPhoto,
      hawbLocalPhoto: hawbLocalPhoto ?? this.hawbLocalPhoto,
      hawbSpecialPhoto: hawbSpecialPhoto ?? this.hawbSpecialPhoto,
      hawbSignature: hawbSignature ?? this.hawbSignature,
      requiredFields: requiredFields ?? this.requiredFields,
      errorFields: errorFields ?? this.errorFields,
      formState: formState ?? this.formState,
    );
  }

  @override
  List<Object?> get props => [
        tipoDeOperacao,
        hawbReceiverType,
        hawbDevolutionReason,
        hawbReceiverName,
        hawbReceiverDocument,
        hawbARPhoto,
        hawbLocalPhoto,
        hawbSpecialPhoto,
        hawbSignature,
        requiredFields,
        errorFields,
        formState,
      ];
}
