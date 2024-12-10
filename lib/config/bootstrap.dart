import 'package:flutter/material.dart';
import 'package:rt_flash/config/dependency_injection.dart';
import 'package:rt_flash/config/main_widget.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const MainWidget());
}
