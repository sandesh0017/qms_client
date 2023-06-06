import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qms_client/view/screens/splash_screen.dart';
import 'package:window_manager/window_manager.dart';

import 'core/local/set_session.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    windowManager.center();
    windowManager.setSkipTaskbar(true);
  });
  //Hive//
  await Hive.initFlutter();
  Hive.registerAdapter(SetSessAdapter());
  await Hive.openBox('myBox');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
