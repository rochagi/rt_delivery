import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:rt_flash/config/theme/app_colors.dart';

import '../cubits/get_lista/get_lista_cubit.dart';

class ListaDialog extends StatelessWidget {
  final ListaCubit getListaCubit;
  const ListaDialog({super.key, required this.getListaCubit});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<TextEditingController> controller =
        ValueNotifier<TextEditingController>(TextEditingController());

    return BlocBuilder<ListaCubit, GetListaState>(
        bloc: getListaCubit,
        builder: (context, state) {
          if (state is GetListaSuccess) {
            Navigator.pop(context);
          }

          return AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              'Pesquisa Lista',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Coloque o código abaixo para buscar a lista',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: controller.value,
                ),
                if (state is GetListaError)
                  Text(
                    state.message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.red),
                  ),
              ],
            ),
            actions: [
              ValueListenableBuilder(
                valueListenable: controller.value,
                builder: (_, value, child) {
                  return CustomElevatedButton(
                    title: 'Buscar',
                    onTap: value.text.isEmpty || state is GetListaLoading
                        ? null
                        : () async {
                            await getListaCubit.getListaFromAPI(
                                listaId: controller.value.text);
                          },
                  );
                },
              )
            ],
          );
        });
  }
}
