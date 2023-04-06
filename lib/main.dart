import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qms_client/view/screens/splash_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    // windowManager.maximize();
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);

    windowManager.center();
    windowManager.setSkipTaskbar(true);
    // await windowManager.setSize(const Size(1000, 600));
    await windowManager.show();
  });

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
