import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/presenter/coleta/cubits/coleta_from_storage/coleta_from_storage_cubit.dart';
import 'package:rt_flash/app/presenter/coleta/cubits/get_coleta_from_api/get_coleta_from_api_cubit.dart';
import 'package:rt_flash/app/presenter/coleta/widgets/coleta_dialog.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:rt_flash/config/app_routes.dart';
import 'package:rt_flash/config/dependency_injection.dart';
import 'package:rt_flash/config/theme/app_colors.dart';

class ColetaPage extends StatefulWidget {
  const ColetaPage({super.key});

  @override
  State<ColetaPage> createState() => _ColetaPageState();
}

class _ColetaPageState extends State<ColetaPage> with RouteAware {
  final _coletaFromApiCubit = injection.get<GetColetaFromApiCubit>();

  final _coletaStorage = injection.get<ColetaFromStorageCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _coletaStorage.getColetaFromStorage();
  }

  @override
  void initState() {
    _coletaStorage.getColetaFromStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RT'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: BlocProvider(
          create: (context) => _coletaFromApiCubit,
          child: BlocListener<GetColetaFromApiCubit, GetColetaFromApiState>(
            listener: (context, state) {
              if (state is GetColetaFromApiSuccess) {
                _coletaStorage.getColetaFromStorage();
              }

              if (state is GetColetaFromApiError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: Column(
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Coletas',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 50),
                BlocBuilder<ColetaFromStorageCubit, ColetaFromStorageState>(
                    bloc: _coletaStorage,
                    builder: (context, state) {
                      if (state is ColetaFromStorageSuccess) {
                        return state.coletas.isEmpty
                            ? Text(
                                'Nenhuma coleta encontrada, insira uma coleta',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: state.coletas.length,
                                  itemBuilder: (context, index) {
                                    final coleta = state.coletas[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: ListTile(
                                        shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.darkBLue,
                                          ),
                                        ),
                                        title: Text(coleta.coletaId!),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${coleta.logradouro ?? ''}, ${coleta.numEnd ?? ''}  ${coleta.complEnd ?? ''}",
                                            ),
                                            Text(
                                                "${coleta.bairro ?? ''}, ${coleta.cep ?? ''}"),
                                            Text(
                                                "${coleta.cidade ?? ''}, ${coleta.uf ?? ''}"),
                                            CustomElevatedButton(
                                              backgroundColor:
                                                  AppColors.lightBlue,
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 5,
                                                  right: 5),
                                              title: 'Iniciar',
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                AppRoutes.finalizarColeta,
                                                arguments: coleta,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      }

                      if (state is ColetaFromStorageLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is ColetaFromStorageError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      return Container();
                    }),
                const SizedBox(height: 50),
                CustomElevatedButton(
                    title: 'Inserir Coleta',
                    onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              ColetaDialog(getColetaCubit: _coletaFromApiCubit),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
