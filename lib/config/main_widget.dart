import 'package:flutter/material.dart';
import 'package:rt_flash/config/theme/app_theme.dart';

import 'app_routes.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      theme: appTheme,
      routes: AppRoutes.routes,
    );
  }
}
