import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/infra/lista/models/hawb_model.dart';
import 'package:rt_flash/app/presenter/home/cubits/check_if_contains_hawbs_to_send_cubit/check_if_contains_hawbs_to_send_cubit.dart';
import 'package:rt_flash/app/presenter/home/cubits/get_lista/get_lista_cubit.dart';
import 'package:rt_flash/app/presenter/home/widgets/lista_dialog.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';
import 'package:rt_flash/config/app_routes.dart';
import 'package:rt_flash/config/dependency_injection.dart';
import 'package:rt_flash/config/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/utils/app_enums.dart';
import '../../../shared/utils/privacy_policy.dart';
import '../cubits/sync/sync_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  ValueNotifier<bool> isAdm = ValueNotifier(false);
  final _listaCubit = injection.get<ListaCubit>();
  final _syncCubit = injection.get<SyncCubit>();

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
    _syncCubit.buscarItemsPendentes();
  }

  @override
  void initState() {
    _listaCubit.getListaFromStorage();
    _syncCubit.buscarItemsPendentes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListaCubit, GetListaState>(
      bloc: _listaCubit,
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('RT'),
            leading: GestureDetector(
              onTap: () {
                isAdm.value = false;
                _scaffoldKey.currentState!.openDrawer();
              },
              onLongPress: () {
                isAdm.value = false;
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Liberar menu Adm'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Digite a senha'),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _controller,
                                  validator: (value) {
                                    if ((value ?? "").isEmpty) {
                                      return 'Preencha a senha';
                                    }

                                    if (value != 'tbmvc') {
                                      return 'Senha incorreta';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                          actions: [
                            CustomElevatedButton(
                                title: 'Liberar',
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    _controller.clear();
                                    Navigator.pop(context);

                                    isAdm.value = true;
                                    _scaffoldKey.currentState!.openDrawer();
                                  }
                                })
                          ],
                        ));
              },
              child: const Icon(
                Icons.menu,
              ),
            ),
          ),
          drawer: ValueListenableBuilder(
              valueListenable: isAdm,
              builder: (context, value, widget) {
                return CustomDrawer(
                  listaCubit: _listaCubit,
                  isAdm: isAdm.value,
                );
              }),
          body: Column(
            children: [
              const SizedBox(height: 50),
              switch (state.runtimeType) {
                const (GetListaLoading) => const CircularProgressIndicator(),
                const (GetListaSuccess) => Column(
                    children: [
                      Text(
                        'Lista: ${(state as GetListaSuccess).lista.lista ?? ''}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Flexible(
                            child: CustomElevatedButton(
                              title: 'Entregar',
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.hawb,
                                    arguments: ListaOperationTypeEnum.entrega);
                              },
                            ),
                          ),
                          Flexible(
                            child: CustomElevatedButton(
                              title: 'Devolução',
                              onTap: () => Navigator.pushNamed(
                                  context, AppRoutes.hawb,
                                  arguments: ListaOperationTypeEnum.devolucao),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                _ => Column(
                    children: [
                      Text(
                        'Nenhuma lista carregada',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                          width: double.infinity,
                          child: CustomElevatedButton(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ListaDialog(getListaCubit: _listaCubit),
                                );
                              },
                              title: 'Inserir Lista')),
                    ],
                  ),
              },
              Row(
                children: [
                  Flexible(
                    child: CustomElevatedButton(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.coleta),
                        title: 'Coletas'),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: state is GetListaSuccess
                          ? AppColors.orange
                          : AppColors.greyMedium,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.screen_search_desktop_sharp,
                      color: AppColors.white,
                      size: 25,
                    ),
                  ),
                  onPressed: state is GetListaSuccess
                      ? () => Navigator.pushNamed(context, AppRoutes.hawbLista,
                          arguments: state.lista.documentos ?? <HawbModel>[])
                      : null,
                ),
                BlocConsumer<SyncCubit, SyncState>(
                  bloc: _syncCubit,
                  listener: (context, syncState) {
                    if (syncState is SyncError) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(syncState.message),
                              backgroundColor: AppColors.red,
                            ),
                          );
                          _syncCubit.buscarItemsPendentes();
                        },
                      );
                    }

                    if (syncState is SyncSuccess) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Sincronizado com sucesso'),
                              backgroundColor: AppColors.darkBLue,
                            ),
                          );
                          _syncCubit.buscarItemsPendentes();
                        },
                      );
                    }
                  },
                  builder: (context, syncState) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: syncState is SyncInitial &&
                                      syncState.itemsToSync > 0
                                  ? AppColors.orange
                                  : AppColors.greyMedium,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.sync,
                              color: AppColors.white,
                              size: 25,
                            ),
                          ),
                          onPressed: state is! SyncLoading
                              ? () => _syncCubit.sync()
                              : null,
                        ),
                        Positioned(
                          right: -1,
                          top: -10,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.darkBLue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              syncState is SyncInitial
                                  ? '${syncState.itemsToSync}'
                                  : '0',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final bool isAdm;
  final ListaCubit listaCubit;

  const CustomDrawer({
    super.key,
    required this.isAdm,
    required this.listaCubit,
  });

  @override
  Widget build(BuildContext context) {
    final checkIfContainsHawbsToSendCubit =
        injection.get<CheckIfContainsHawbsToSendCubit>();

    ScrollController scrollController = ScrollController();
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          Text(
            'Menu',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 50,
          ),
          if (isAdm)
            Column(
              children: [
                BlocBuilder<CheckIfContainsHawbsToSendCubit,
                    CheckIfContainsHawbsToSendState>(
                  bloc: checkIfContainsHawbsToSendCubit,
                  builder: (context, state) {
                    if (state is CheckIfContainsHawbsToSendLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is CheckIfContainsHawbsToSendSuccess &&
                        state.containsHawbs) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Atenção'),
                              content: const Text(
                                  'Existem Hawbs para enviar, deseja apagar todos os dados?'),
                              actions: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: CustomElevatedButton(
                                          title: 'Sim',
                                          onTap: () {
                                            listaCubit.resetLista();
                                            Navigator.pop(context);
                                          }),
                                    ),
                                    Flexible(
                                      child: CustomElevatedButton(
                                          title: 'Não',
                                          onTap: () {
                                            Navigator.pop(context);
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      });
                    }
                    if (state is CheckIfContainsHawbsToSendSuccess &&
                        !state.containsHawbs) {
                      listaCubit.resetLista();
                    }

                    return InkWell(
                      onTap: listaCubit.state is GetListaInitial
                          ? null
                          : () {
                              checkIfContainsHawbsToSendCubit.check();
                            },
                      child: Text(
                        'Limpar lista',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppColors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  child: Text(
                    'Limpar dados',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            child: Text(
              'Configurar',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Politica de Privacidade',
                        style: Theme.of(context).textTheme.titleSmall),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                content: Scrollbar(
                    interactive: true,
                    thumbVisibility: true,
                    controller: scrollController,
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: const Text(privacyPolicy))),
                actions: [
                  CustomElevatedButton(
                    title: 'Saiba mais',
                    onTap: () {
                      try {
                        final Uri url = Uri.parse(
                            'https://www.flashcourier.com.br/politica-de-privacidade-rt');

                        launchUrl(url, mode: LaunchMode.platformDefault);
                      } catch (e) {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
            child: Text(
              'Politica de privacidade',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => SystemNavigator.pop(),
            child: Text(
              'Encerrar o app',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.white),
            ),
          ),
        ],
      )),
    );
  }
}
