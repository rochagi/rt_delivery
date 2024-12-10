import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:rt_flash/config/theme/app_colors.dart';

import '../cubits/get_coleta_from_api/get_coleta_from_api_cubit.dart';

class ColetaDialog extends StatelessWidget {
  final GetColetaFromApiCubit getColetaCubit;
  const ColetaDialog({super.key, required this.getColetaCubit});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<TextEditingController> controller =
        ValueNotifier<TextEditingController>(TextEditingController());

    return BlocBuilder<GetColetaFromApiCubit, GetColetaFromApiState>(
        bloc: getColetaCubit,
        builder: (context, state) {
          if (state is GetColetaFromApiSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              getColetaCubit.resetState();
            });
          }

          return AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              'Pesquisa Coleta',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Coloque o código abaixo para buscar a coleta',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: controller.value,
                ),
                if (state is GetColetaFromApiError)
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
                    onTap:
                        value.text.isEmpty || state is GetColetaFromApiLoading
                            ? null
                            : () async {
                                await getColetaCubit.getColetaFromAPI(
                                    coletaId: controller.value.text);
                              },
                  );
                },
              )
            ],
          );
        });
  }
}
