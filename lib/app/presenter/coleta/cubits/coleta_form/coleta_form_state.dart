part of 'coleta_form_cubit.dart';

final class ColetaFormDefaultState extends Equatable {
  final String tipo;
  final String identificacao;
  final String rg;
  final String fotoProdutoColetado;
  final String fotoLocalColeta;
  final String fotoPedidoColeta;
  final String fotoForaDoAlvo;
  final List<ColetaFormFieldsEnum> requiredFields;
  final List<ColetaFormFieldsEnum> errorFields;
  final FormStateEnum formState;

  const ColetaFormDefaultState({
    this.tipo = 'COLETADO',
    this.identificacao = '',
    this.rg = '',
    this.fotoProdutoColetado = '',
    this.fotoLocalColeta = '',
    this.fotoPedidoColeta = '',
    this.fotoForaDoAlvo = '',
    this.requiredFields = const [],
    this.errorFields = const [],
    this.formState = FormStateEnum.initial,
  });

  ColetaFormDefaultState copyWith({
    String? tipo,
    String? identificacao,
    String? rg,
    String? fotoProdutoColetado,
    String? fotoLocalColeta,
    String? fotoPedidoColeta,
    String? fotoForaDoAlvo,
    List<ColetaFormFieldsEnum>? requiredFields,
    List<ColetaFormFieldsEnum>? errorFields,
    FormStateEnum? formState,
  }) {
    return ColetaFormDefaultState(
      tipo: tipo ?? this.tipo,
      identificacao: identificacao ?? this.identificacao,
      rg: rg ?? this.rg,
      fotoProdutoColetado: fotoProdutoColetado ?? this.fotoProdutoColetado,
      fotoLocalColeta: fotoLocalColeta ?? this.fotoLocalColeta,
      fotoPedidoColeta: fotoPedidoColeta ?? this.fotoPedidoColeta,
      fotoForaDoAlvo: fotoForaDoAlvo ?? this.fotoForaDoAlvo,
      requiredFields: requiredFields ?? this.requiredFields,
      errorFields: errorFields ?? this.errorFields,
      formState: formState ?? this.formState,
    );
  }

  @override
  List<Object> get props => [
        tipo,
        identificacao,
        rg,
        fotoProdutoColetado,
        fotoLocalColeta,
        fotoPedidoColeta,
        fotoForaDoAlvo,
        requiredFields,
        errorFields,
        formState,
      ];
}
