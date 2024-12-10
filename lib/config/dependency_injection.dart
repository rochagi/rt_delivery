import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rt_flash/app/infra/coleta/datasources/remote/finalizar_coleta_remote_datasource.dart';
import 'package:rt_flash/app/infra/images/datasources/remote/images_remote_datasource.dart';
import 'package:rt_flash/app/infra/lista/datasources/local/lista_local_datasource.dart';
import 'package:rt_flash/app/infra/session/datasource/remote/session_api_auth.dart';
import 'package:rt_flash/app/presenter/coleta/cubits/coleta_form/coleta_form_cubit.dart';
import 'package:rt_flash/app/presenter/coleta/cubits/coleta_from_storage/coleta_from_storage_cubit.dart';
import 'package:rt_flash/app/presenter/hawb/cubits/get_hawbs/get_hawbs_cubit.dart';
import 'package:rt_flash/app/presenter/hawb/cubits/hawb_form/hawb_form_cubit.dart';
import 'package:rt_flash/app/presenter/home/cubits/get_lista/get_lista_cubit.dart';
import 'package:rt_flash/app/presenter/login/cubits/cubit/auth_cubit.dart';
import 'package:rt_flash/app/presenter/login/cubits/master_key/master_key_cubit.dart';
import 'package:rt_flash/app/presenter/splash/cubit/splash_cubit.dart';
import 'package:rt_flash/app/shared/api_client/dio/api_client_dio_impl.dart';
import 'package:rt_flash/app/shared/api_client/i_api_client.dart';

import 'package:rt_flash/app/shared/preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../app/infra/coleta/datasources/local/coleta_local_datasource.dart';
import '../app/infra/coleta/datasources/local/finalizar_coleta_local_datasource.dart';
import '../app/infra/coleta/datasources/remote/coleta_remote_datasource.dart';
import '../app/infra/images/datasources/local/images_local_datasource.dart';
import '../app/infra/lista/datasources/remote/lista_remote_datasource.dart';
import '../app/presenter/coleta/cubits/get_coleta_from_api/get_coleta_from_api_cubit.dart';
import '../app/presenter/home/cubits/check_if_contains_hawbs_to_send_cubit/check_if_contains_hawbs_to_send_cubit.dart';
import '../app/presenter/home/cubits/sync/sync_cubit.dart';
import '../app/shared/database/database_imports.dart';

final injection = GetIt.instance;

Future<void> initInjection() async {
  //Base libs

  SharedPreferences preferences = await SharedPreferences.getInstance();
  injection.registerLazySingleton<IPreferences>(
      () => PreferencesImpl(preferences: preferences));
  Database database = await DatabaseHelper.instance;
  injection.registerLazySingleton<IDatabaseOperations>(
      () => DatabaseOperationsImpl(database: database));
  Dio dio = Dio();
  injection.registerLazySingleton<IApiClient>(() =>
      ApiClientDioImpl(dio: dio, preferences: injection.get<IPreferences>()));

  //Splash
  injection.registerFactory<SplashCubit>(
      () => SplashCubit(preferences: injection.get<IPreferences>()));

  //Login
  injection.registerFactory<MasterKeyCubit>(
      () => MasterKeyCubit(preferences: injection.get<IPreferences>()));

  injection.registerFactory<ISessionApiAuth>(
      () => SessionApiAuth(apiClient: injection.get<IApiClient>()));

  injection.registerFactory<AuthCubit>(() => AuthCubit(
      sessionApiAuth: injection.get<ISessionApiAuth>(),
      preferences: injection.get<IPreferences>()));

//Images
  injection.registerFactory<IImagesLocalDatasource>(() =>
      ImagesLocalDatasource(database: injection.get<IDatabaseOperations>()));
  injection.registerFactory<IImagesRemoteDatasource>(
      () => ImagesRemoteDatasource(apiClient: injection.get<IApiClient>()));
//Lista
  injection.registerFactory<IListaRemoteDatasource>(
      () => ListaRemoteDatasource(apiClient: injection.get<IApiClient>()));
  injection.registerFactory<IListaLocalDatasource>(() =>
      ListaLocalDatasource(database: injection.get<IDatabaseOperations>()));

  injection.registerFactory<ListaCubit>(() => ListaCubit(
        getListaRemoteDatasource: injection.get<IListaRemoteDatasource>(),
        listaLocalDatasource: injection.get<IListaLocalDatasource>(),
      ));

  //HAwb

  injection.registerFactory<GetHawbsCubit>(() => GetHawbsCubit(
        listaLocalDatasource: injection.get<IListaLocalDatasource>(),
      ));

  //HawbForm
  injection.registerFactory<HawbFormCubit>(() => HawbFormCubit(
        listaLocalDatasource: injection.get<IListaLocalDatasource>(),
        imagesLocalDatasource: injection.get<IImagesLocalDatasource>(),
      ));

  //CheckIfContainsHawbsToSend
  injection.registerFactory<CheckIfContainsHawbsToSendCubit>(() =>
      CheckIfContainsHawbsToSendCubit(
          listaLocalDatasource: injection.get<IListaLocalDatasource>()));

  //Coleta
  injection.registerFactory<IColetaRemoteDatasource>(
      () => ColetaRemoteDatasource(apiClient: injection.get<IApiClient>()));
  injection.registerFactory<IColetaLocalDatasource>(() =>
      ColetaLocalDatasource(database: injection.get<IDatabaseOperations>()));

  injection.registerFactory<IFinalizarColetaLocalDatasource>(() =>
      FinalizarColetaLocalDatasource(
          database: injection.get<IDatabaseOperations>()));

  injection.registerFactory<IFinalizarColetaRemoteDatasource>(() =>
      FinalizarColetaRemoteDatasource(apiClient: injection.get<IApiClient>()));

  injection.registerFactory<GetColetaFromApiCubit>(() => GetColetaFromApiCubit(
        getColetaRemoteDatasource: injection.get<IColetaRemoteDatasource>(),
        coletaLocalDatasource: injection.get<IColetaLocalDatasource>(),
      ));

  injection
      .registerFactory<ColetaFromStorageCubit>(() => ColetaFromStorageCubit(
            coletaLocalDatasource: injection.get<IColetaLocalDatasource>(),
          ));

  injection.registerFactory<ColetaFormCubit>(() => ColetaFormCubit(
        imagesLocalDatasource: injection.get<IImagesLocalDatasource>(),
        finalizarColetaLocalDatasource:
            injection.get<IFinalizarColetaLocalDatasource>(),
        coletaLocalDatasource: injection.get<IColetaLocalDatasource>(),
      ));

  injection.registerFactory<SyncCubit>(() => SyncCubit(
        listaLocalDatasource: injection.get<IListaLocalDatasource>(),
        listaRemoteDatasource: injection.get<IListaRemoteDatasource>(),
        finalizarColetaLocalDatasource:
            injection.get<IFinalizarColetaLocalDatasource>(),
        finalizarColetaRemoteDatasource:
            injection.get<IFinalizarColetaRemoteDatasource>(),
        imagesLocalDatasource: injection.get<IImagesLocalDatasource>(),
        imagesRemoteDatasource: injection.get<IImagesRemoteDatasource>(),
      ));
}
