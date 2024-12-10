import 'dart:developer';
import 'dart:io';

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rt_flash/app/infra/lista/models/hawb_model.dart';
import 'package:rt_flash/app/infra/lista/models/recebedor_model.dart';
import 'package:rt_flash/app/infra/lista/models/situacao_model.dart';
import 'package:rt_flash/app/presenter/hawb/cubits/get_hawbs/get_hawbs_cubit.dart';
import 'package:rt_flash/app/presenter/hawb/cubits/hawb_form/hawb_form_cubit.dart';
import 'package:rt_flash/app/shared/utils/app_enums.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:rt_flash/config/dependency_injection.dart';
import 'package:signature/signature.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../shared/utils/validators.dart';

class HawbPage extends StatefulWidget {
  const HawbPage({super.key});

  @override
  State<HawbPage> createState() => _HawbPageState();
}

class HawbSelectedCubit extends Cubit<HawbModel?> {
  HawbSelectedCubit() : super(null);

  void change({HawbModel? newValue}) => emit(newValue);
}

class _HawbPageState extends State<HawbPage> {
  late final GetHawbsCubit _getHawbsCubit;
  final TextEditingController _dropdownSearchFieldController =
      TextEditingController();

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  final HawbSelectedCubit _hawbSelectedCubit = HawbSelectedCubit();
  final HawbFormCubit _hawbFormCubit = injection.get<HawbFormCubit>();
  HawbModel? _hawbSelected;
  int? _receiverId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();

  final Set<HawbFieldsEnum> _requiredFields = {};
  bool ehMaoPropria = false;
  ListaOperationTypeEnum? listaOperationTypeEnum;
  bool signatureError = false;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    _getHawbsCubit = injection.get<GetHawbsCubit>();
    _getHawbsCubit.getHawbs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listaOperationTypeEnum ??=
        ModalRoute.settingsOf(context)!.arguments as ListaOperationTypeEnum;
    resetFields() {
      _receiverId = null;
      _nameController.clear();
      _rgController.clear();
      _controller.clear();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'RT - ${listaOperationTypeEnum == ListaOperationTypeEnum.entrega ? 'Entrega' : 'Devolução'}'),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<GetHawbsCubit, GetHawbsState>(
            bloc: _getHawbsCubit,
            builder: (context, state) {
              if (state is GetHawbsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetHawbsSuccess) {
                List<HawbModel> getSuggestions(String query) {
                  List<HawbModel> matches = state.hawbs;

                  matches.retainWhere(
                      (s) => (s.codHawb ?? '').contains(query.toLowerCase()));
                  return matches;
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropDownSearchFormField<HawbModel>(
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration: const InputDecoration(
                              labelText: 'Pesquisar Hawb'),
                          controller: _dropdownSearchFieldController,
                        ),
                        suggestionsCallback: (pattern) {
                          return getSuggestions(pattern);
                        },
                        itemBuilder: (context, HawbModel suggestion) {
                          return ListTile(
                            title: Text(suggestion.codHawb ?? 'N/A'),
                          );
                        },
                        itemSeparatorBuilder: (context, index) {
                          return const Divider();
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        noItemsFoundBuilder: (context) =>
                            const Text('Nenhuma Hawb encontrada'),
                        onSuggestionSelected: (HawbModel suggestion) {
                          log("suggestion: $suggestion");

                          _hawbSelectedCubit.change(newValue: suggestion);
                          _hawbSelected = suggestion;
                          _dropdownSearchFieldController.text =
                              suggestion.codHawb ?? '';

                          resetFields();
                        },
                        suggestionsBoxController: suggestionBoxController,
                        validator: (value) =>
                            value!.isEmpty ? 'Selecione uma Hawb' : null,
                        displayAllSuggestionWhenTap: true,
                      ),
                      BlocBuilder<HawbSelectedCubit, HawbModel?>(
                        bloc: _hawbSelectedCubit,
                        builder: (context, state) {
                          if (state != null) {
                            _requiredFields.clear();
                            _requiredFields.addAll([
                              if (listaOperationTypeEnum ==
                                  ListaOperationTypeEnum.entrega)
                                HawbFieldsEnum.hawbReceiverType,
                              if (listaOperationTypeEnum ==
                                  ListaOperationTypeEnum.devolucao)
                                HawbFieldsEnum.hawbDevolutionReason,
                            ]);
                            _requiredFields
                                .addAll(_hawbSelected!.requiredFields);
                            return BlocSelector<HawbFormCubit, HawbFormState,
                                FormStateEnum>(
                              bloc: _hawbFormCubit,
                              selector: (state) => state.formState,
                              builder: (context, hawbFormState) {
                                if (hawbFormState == FormStateEnum.success) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Hawb salva com sucesso'),
                                        ),
                                      )
                                      .closed
                                      .then((reason) {
                                    resetFields();
                                    _hawbSelectedCubit.change(newValue: null);
                                    _dropdownSearchFieldController.clear();
                                    _hawbFormCubit.resetState();
                                  });
                                }

                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Text(
                                        'Hawb selecionada: ${state.codHawb}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        if (listaOperationTypeEnum ==
                                            ListaOperationTypeEnum.entrega)
                                          BlocSelector<
                                              HawbFormCubit, //TIPO DE RECEBEDOR
                                              HawbFormState,
                                              int?>(
                                            bloc: _hawbFormCubit,
                                            selector: (state) =>
                                                state.hawbReceiverType,
                                            builder:
                                                (context, hawbReceiverType) {
                                              return DropdownButtonFormField(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Selecione o recebedor',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                items: RecebedorModel
                                                    .tipoRecebedores
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                              value: e.id,
                                                              child: Text(
                                                                  e.nome,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      )),
                                                            ))
                                                    .toList(),
                                                onChanged: (value) =>
                                                    _hawbFormCubit
                                                        .atualizarTipoDeRecebedor(
                                                            value),
                                              );
                                            },
                                          ),
                                        BlocSelector<
                                            HawbFormCubit, //TIPO DE RECEBEDOR ERRO
                                            HawbFormState,
                                            bool>(
                                          bloc: _hawbFormCubit,
                                          selector: (state) => state.errorFields
                                              .contains(HawbFieldsEnum
                                                  .hawbReceiverType),
                                          builder: (context, state) {
                                            return Visibility(
                                              visible: state,
                                              child: Text(
                                                'Campo obrigatório',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            );
                                          },
                                        ),
                                        if (listaOperationTypeEnum ==
                                            ListaOperationTypeEnum.devolucao)
                                          BlocSelector<
                                              HawbFormCubit, //MOTIVO DA DEVOLUÇÃO
                                              HawbFormState,
                                              int?>(
                                            bloc: _hawbFormCubit,
                                            selector: (state) =>
                                                state.hawbDevolutionReason,
                                            builder: (context,
                                                hawbDevolutionReason) {
                                              return DropdownButtonFormField(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Selecione o motivo',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                items: SituacaoModel
                                                    .situacaoModel
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                              value: e.id,
                                                              child: Text(
                                                                  e.nome,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      )),
                                                            ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  _hawbFormCubit
                                                      .atualizarMotivoDevolucao(
                                                          value);
                                                },
                                              );
                                            },
                                          ),
                                        BlocSelector<
                                            HawbFormCubit, //MOTIVO DA DEVOLUÇÃO ERRO
                                            HawbFormState,
                                            bool>(
                                          bloc: _hawbFormCubit,
                                          selector: (state) => state.errorFields
                                              .contains(HawbFieldsEnum
                                                  .hawbDevolutionReason),
                                          builder: (context, state) {
                                            return Visibility(
                                              visible: state,
                                              child: Text(
                                                'Campo obrigatório',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            );
                                          },
                                        ),
                                        if (_hawbSelected!.requiredFields
                                            .contains(
                                                HawbFieldsEnum.hawbSignature))
                                          Column(
                                            children: [
                                              Text('Assinatura',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium),
                                              BlocSelector<
                                                  HawbFormCubit, //ASSINATURA
                                                  HawbFormState,
                                                  String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbSignature,
                                                builder: (context, state) {
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color:
                                                                AppColors.black,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Signature(
                                                          controller:
                                                              _controller,
                                                          height: 150,
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              _controller
                                                                  .clear();
                                                              _hawbFormCubit
                                                                  .atualizarFotoAssinatura(
                                                                      '');
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete)),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              BlocSelector<
                                                  HawbFormCubit, //ASSINATURA ERRO
                                                  HawbFormState,
                                                  bool>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) => state
                                                    .errorFields
                                                    .contains(HawbFieldsEnum
                                                        .hawbSignature),
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state,
                                                    child: Text(
                                                      'Campo obrigatório',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  AppColors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        if (_hawbSelected!.requiredFields
                                            .contains(HawbFieldsEnum
                                                .hawbReceiverName))
                                          Column(
                                            children: [
                                              const Text('RG e Nome'),
                                              BlocSelector< //RG
                                                  HawbFormCubit,
                                                  HawbFormState,
                                                  String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbReceiverDocument,
                                                builder: (context, state) {
                                                  return TextFormField(
                                                    onChanged: (value) =>
                                                        _hawbFormCubit
                                                            .atualizarDocumentoRecebedor(
                                                                value),
                                                    onTapOutside: (event) =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    controller: _rgController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'RG',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'[0-9xX]')),
                                                    ],
                                                    validator:
                                                        Validators.rgValidator,
                                                  );
                                                },
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, bool>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) => state
                                                    .errorFields
                                                    .contains(HawbFieldsEnum
                                                        .hawbReceiverDocument),
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state,
                                                    child: Text(
                                                      'Campo obrigatório',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  AppColors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Text(
                                                'Campo obrigatório',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, String>(
                                                selector: (state) =>
                                                    state.hawbReceiverName,
                                                bloc: _hawbFormCubit,
                                                builder: (context, state) {
                                                  return TextFormField(
                                                    onChanged: (value) =>
                                                        _hawbFormCubit
                                                            .atualizarNomeRecebedor(
                                                                value),
                                                    onTapOutside: (event) =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    controller: _nameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Nome',
                                                    ),
                                                  );
                                                },
                                              ),
                                              BlocSelector<
                                                  HawbFormCubit, //NOME ERRO
                                                  HawbFormState,
                                                  bool>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) => state
                                                    .errorFields
                                                    .contains(HawbFieldsEnum
                                                        .hawbReceiverName),
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state,
                                                    child: Text(
                                                      'Campo obrigatório',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  AppColors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        if (_hawbSelected!.requiredFields
                                            .contains(
                                                HawbFieldsEnum.hawbARPhoto))
                                          Column(
                                            children: [
                                              const SizedBox(height: 15),
                                              const Text('Foto do AR'),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  ImagePicker picker =
                                                      ImagePicker();
                                                  await picker
                                                      .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 40,
                                                          maxHeight: 800,
                                                          maxWidth: 800)
                                                      .then(
                                                    (foto) {
                                                      if (foto?.path != null) {
                                                        _hawbFormCubit
                                                            .atualizarFotoAR(
                                                          foto!.path,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                    Icons.photo_camera),
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbARPhoto,
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state.isNotEmpty,
                                                    child: SizedBox(
                                                      height: 200,
                                                      child: Image.file(
                                                          File(state)),
                                                    ),
                                                  );
                                                },
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, bool>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) => state
                                                    .errorFields
                                                    .contains(HawbFieldsEnum
                                                        .hawbARPhoto),
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state,
                                                    child: Text(
                                                      'Campo obrigatório',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  AppColors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  );
                                                },
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbARPhoto,
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state.isNotEmpty,
                                                    child: SizedBox(
                                                      height: 200,
                                                      child: Image.file(
                                                          File(state)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        if (_hawbSelected!.requiredFields
                                            .contains(
                                                HawbFieldsEnum.hawbLocalPhoto))
                                          Column(
                                            children: [
                                              const SizedBox(height: 15),
                                              const Text('Foto do AR'),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  ImagePicker picker =
                                                      ImagePicker();
                                                  await picker
                                                      .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 40,
                                                          maxHeight: 800,
                                                          maxWidth: 800)
                                                      .then(
                                                    (foto) {
                                                      if (foto?.path != null) {
                                                        _hawbFormCubit
                                                            .atualizarFotoLocal(
                                                          foto!.path,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                    Icons.photo_camera),
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbLocalPhoto,
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state.isNotEmpty,
                                                    child: SizedBox(
                                                      height: 200,
                                                      child: Image.file(
                                                          File(state)),
                                                    ),
                                                  );
                                                },
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, bool>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) => state
                                                    .errorFields
                                                    .contains(HawbFieldsEnum
                                                        .hawbLocalPhoto),
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state,
                                                    child: Text(
                                                      'Campo obrigatório',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  AppColors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  );
                                                },
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbARPhoto,
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state.isNotEmpty,
                                                    child: SizedBox(
                                                      height: 200,
                                                      child: Image.file(
                                                          File(state)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        if (_hawbSelected!.requiredFields
                                            .contains(HawbFieldsEnum
                                                .hawbSpecialPhoto))
                                          Column(
                                            children: [
                                              const SizedBox(height: 15),
                                              const Text('Foto especial'),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  ImagePicker picker =
                                                      ImagePicker();
                                                  await picker
                                                      .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 40,
                                                          maxHeight: 800,
                                                          maxWidth: 800)
                                                      .then(
                                                    (foto) {
                                                      if (foto?.path != null) {
                                                        _hawbFormCubit
                                                            .atualizarFotoEspecial(
                                                          foto!.path,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                    Icons.photo_camera),
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, String>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) =>
                                                    state.hawbSpecialPhoto,
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state.isNotEmpty,
                                                    child: SizedBox(
                                                      height: 200,
                                                      child: Image.file(
                                                          File(state)),
                                                    ),
                                                  );
                                                },
                                              ),
                                              BlocSelector<HawbFormCubit,
                                                  HawbFormState, bool>(
                                                bloc: _hawbFormCubit,
                                                selector: (state) => state
                                                    .errorFields
                                                    .contains(HawbFieldsEnum
                                                        .hawbSpecialPhoto),
                                                builder: (context, state) {
                                                  return Visibility(
                                                    visible: state,
                                                    child: Text(
                                                      'Campo obrigatório',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  AppColors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    ],
                  ),
                );
              } else if (state is GetHawbsFailure) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const Center(
                  child: Text('Erro desconhecido'),
                );
              }
            },
          ),
        ),
        bottomNavigationBar:
            BlocSelector<HawbFormCubit, HawbFormState, FormStateEnum>(
          selector: (state) => state.formState,
          bloc: _hawbFormCubit,
          builder: (context, formState) {
            return CustomElevatedButton(
                title: 'Salvar',
                onTap: formState == FormStateEnum.loading
                    ? null
                    : () {
                        if (_hawbSelected != null) {
                          if (listaOperationTypeEnum ==
                                  ListaOperationTypeEnum.devolucao &&
                              _hawbSelected!.requiredFields.contains(
                                  HawbFieldsEnum.hawbCaixaDeCorrespondecia) &&
                              _hawbSelected!.tentativas != null &&
                              _hawbSelected!.tentativas! < 3) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.white,
                                title: Text(
                                  'Erro',
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                content: Text(
                                    'Esta Hawb pode ser entregue na caixa de correspondência, certeza que deseja devolver?',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomElevatedButton(
                                          title: 'Devolver',
                                          onTap: () {
                                            _hawbFormCubit.validadeHawbForm(
                                              hawb: _hawbSelected!,
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomElevatedButton(
                                          title: 'Entregar',
                                          onTap: () {
                                            Navigator.pop(context);
                                            _requiredFields.clear();
                                            setState(() {
                                              listaOperationTypeEnum =
                                                  ListaOperationTypeEnum
                                                      .entrega;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );

                            return;
                          }

                          if (_receiverId != 1 &&
                              _hawbSelected!.requiredFields.contains(
                                  HawbFieldsEnum.hawbRecebimentoMaoPropria) &&
                              listaOperationTypeEnum ==
                                  ListaOperationTypeEnum.entrega) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.white,
                                title: Text(
                                  'Erro',
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                content: Text(
                                    'Esta Hawb só pode ser entregue a própria pessoa, mude o tipo de recebedor ou realize a devolução',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomElevatedButton(
                                          title: 'Cancelar',
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomElevatedButton(
                                          title: 'Devolver',
                                          onTap: () {
                                            Navigator.pop(context);
                                            _requiredFields.clear();
                                            setState(() {
                                              listaOperationTypeEnum =
                                                  ListaOperationTypeEnum
                                                      .devolucao;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );

                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.white,
                              title: Text(
                                'Erro',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              content: Text('Selecione o motivo da devolução',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                        title: 'Cancelar',
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );

                          return;
                        }

                        _hawbFormCubit.validadeHawbForm(
                          hawb: _hawbSelected!,
                        );
                      });
          },
        ),
      ),
    );
  }
}
