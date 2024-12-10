import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rt_flash/app/infra/coleta/models/coleta.dart';
import 'package:rt_flash/app/presenter/coleta/cubits/coleta_form/coleta_form_cubit.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:rt_flash/config/dependency_injection.dart';
import 'package:rt_flash/config/theme/app_colors.dart';

import '../../../shared/utils/app_enums.dart';
import '../../../shared/utils/validators.dart';

class FinalizarColetaPage extends StatelessWidget {
  const FinalizarColetaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formCubit = injection.get<ColetaFormCubit>();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController identificacaoController = TextEditingController();
    TextEditingController rgController = TextEditingController();
    FocusNode identificacaoFocus = FocusNode();
    FocusNode rgFocus = FocusNode();

    ColetaModel coleta =
        ModalRoute.of(context)!.settings.arguments! as ColetaModel;

    formCubit.updateRequiredFields(coleta.requiredFields);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RT'),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'Finalizar coleta ${coleta.coletaId ?? ''}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 5),
              BlocSelector<ColetaFormCubit, ColetaFormDefaultState, String>(
                bloc: formCubit,
                selector: (state) => state.tipo,
                builder: (context, tipo) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Coletado',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Radio(
                            value: 'COLETADO',
                            groupValue: tipo,
                            onChanged: (value) => formCubit.updateTipo(value!),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Não coletado',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Radio(
                            value: 'NAO_COLETADO',
                            groupValue: tipo,
                            onChanged: (value) => formCubit.updateTipo(value!),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                onTapOutside: (event) => identificacaoFocus.unfocus(),
                focusNode: identificacaoFocus,
                controller: identificacaoController,
                decoration: const InputDecoration(
                  labelText: 'IDENTIFICAÇÃO',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
                onChanged: (value) => formCubit.updateIdentificacao(value),
              ),
              const SizedBox(height: 15),
              TextFormField(
                onTapOutside: (event) => rgFocus.unfocus(),
                focusNode: rgFocus,
                controller: rgController,
                decoration: const InputDecoration(
                  labelText: 'RG',
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9xX]')),
                ],
                validator: Validators.rgValidator,
                onChanged: (value) => formCubit.updateIdentificacao(value),
              ),
              if (coleta.requiredFields
                  .contains(ColetaFormFieldsEnum.fotoProdutoColetado))
                Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('Foto do produto coletado'),
                    ElevatedButton(
                      onPressed: () async {
                        ImagePicker picker = ImagePicker();
                        await picker
                            .pickImage(
                                source: ImageSource.camera,
                                imageQuality: 40,
                                maxHeight: 800,
                                maxWidth: 800)
                            .then(
                          (fotoProdutoColetado) {
                            if (fotoProdutoColetado?.path != null) {
                              formCubit.updateFotoProdutoColetado(
                                  fotoProdutoColetado?.path);
                            }
                          },
                        );
                      },
                      child: const Icon(Icons.photo_camera),
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState, bool>(
                      bloc: formCubit,
                      selector: (state) => state.errorFields
                          .contains(ColetaFormFieldsEnum.fotoProdutoColetado),
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
                                    fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState,
                        String>(
                      bloc: formCubit,
                      selector: (state) => state.fotoProdutoColetado,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.isNotEmpty,
                          child: SizedBox(
                            height: 200,
                            child: Image.file(File(state)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (coleta.requiredFields
                  .contains(ColetaFormFieldsEnum.fotoLocalColeta))
                Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('Foto do local da coleta'),
                    ElevatedButton(
                      onPressed: () async {
                        ImagePicker picker = ImagePicker();

                        await picker
                            .pickImage(
                                source: ImageSource.camera,
                                imageQuality: 40,
                                maxHeight: 800,
                                maxWidth: 800)
                            .then(
                          (fotoLocalColeta) {
                            if (fotoLocalColeta?.path != null) {
                              formCubit.updateFotoLocalColeta(
                                fotoLocalColeta?.path,
                              );
                            }
                          },
                        );
                      },
                      child: const Icon(Icons.photo_camera),
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState, bool>(
                      bloc: formCubit,
                      selector: (state) => state.errorFields
                          .contains(ColetaFormFieldsEnum.fotoLocalColeta),
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
                                    fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState,
                        String>(
                      bloc: formCubit,
                      selector: (state) => state.fotoLocalColeta,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.isNotEmpty,
                          child: SizedBox(
                            height: 200,
                            child: Image.file(File(state)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (coleta.requiredFields
                  .contains(ColetaFormFieldsEnum.fotoPedidoColeta))
                Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('Foto pedido de coleta'),
                    ElevatedButton(
                      onPressed: () async {
                        ImagePicker picker = ImagePicker();
                        await picker
                            .pickImage(
                                source: ImageSource.camera,
                                imageQuality: 40,
                                maxHeight: 800,
                                maxWidth: 800)
                            .then(
                          (fotoPedidoColeta) {
                            if (fotoPedidoColeta?.path != null) {
                              formCubit.updateFotoPedidoColeta(
                                fotoPedidoColeta?.path,
                              );
                            }
                          },
                        );
                      },
                      child: const Icon(Icons.photo_camera),
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState, bool>(
                      bloc: formCubit,
                      selector: (state) => state.errorFields
                          .contains(ColetaFormFieldsEnum.fotoPedidoColeta),
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
                                    fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState,
                        String>(
                      bloc: formCubit,
                      selector: (state) => state.fotoPedidoColeta,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.isNotEmpty,
                          child: SizedBox(
                            height: 200,
                            child: Image.file(File(state)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (coleta.requiredFields
                  .contains(ColetaFormFieldsEnum.fotoForaDoAlvo))
                Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text('Foto fora do alvo'),
                    ElevatedButton(
                      onPressed: () async {
                        ImagePicker picker = ImagePicker();
                        await picker
                            .pickImage(
                                source: ImageSource.camera,
                                imageQuality: 40,
                                maxHeight: 800,
                                maxWidth: 800)
                            .then(
                          (fotoForaDoAlvo) {
                            if (fotoForaDoAlvo?.path != null) {
                              formCubit.updateFotoForaDoAlvo(
                                fotoForaDoAlvo?.path,
                              );
                            }
                          },
                        );
                      },
                      child: const Icon(Icons.photo_camera),
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState, bool>(
                      bloc: formCubit,
                      selector: (state) => state.errorFields
                          .contains(ColetaFormFieldsEnum.fotoForaDoAlvo),
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
                                    fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    BlocSelector<ColetaFormCubit, ColetaFormDefaultState,
                        String>(
                      bloc: formCubit,
                      selector: (state) => state.fotoForaDoAlvo,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.isNotEmpty,
                          child: SizedBox(
                            height: 200,
                            child: Image.file(File(state)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              Column(
                children: [
                  const SizedBox(height: 15),
                  BlocSelector<ColetaFormCubit, ColetaFormDefaultState,
                      FormStateEnum>(
                    selector: (state) => state.formState,
                    bloc: formCubit,
                    builder: (context, state) {
                      if (state == FormStateEnum.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state == FormStateEnum.error) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.red,
                            content: const Text(
                                'Erro ao salvar coleta'), //TODO: tratar melhor erros
                          ),
                        );
                      }

                      if (state == FormStateEnum.success) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pop(context);

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Coleta finalizada',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                content: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Coleta ',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: '${coleta.coletaId} ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: 'finalizada',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ])),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('FECHAR'),
                                  )
                                ],
                              );
                            },
                          );
                        });
                      }

                      return CustomElevatedButton(
                        title: 'Finalizar',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formCubit.validate(coleta: coleta);
                          }
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
