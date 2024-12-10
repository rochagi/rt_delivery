import 'package:flutter/material.dart';
import 'package:rt_flash/app/presenter/hawb/page/hawb_page.dart';
import 'package:rt_flash/app/presenter/home/page/home_page.dart';
import 'package:rt_flash/app/presenter/login/page/login_page.dart';
import 'package:rt_flash/app/presenter/splash/page/splash_page.dart';

import '../app/presenter/coleta/page/coleta_page.dart';
import '../app/presenter/coleta/page/finalizar_coleta_page.dart';
import '../app/presenter/hawb/page/hawb_lista_page.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const hawb = '/hawb';
  static const coleta = '/coleta';
  static const finalizarColeta = '/finalizar-coleta';
  static const hawbLista = '/hawb-lista';

  static final routes = {
    splash: (BuildContext context) => const SplashPage(),
    login: (BuildContext context) => const LoginPage(),
    home: (BuildContext context) => const HomePage(),
    hawb: (BuildContext context) => const HawbPage(),
    coleta: (BuildContext context) => const ColetaPage(),
    finalizarColeta: (BuildContext context) => const FinalizarColetaPage(),
    hawbLista: (BuildContext context) => const HawbListaPage(),
  };
}
