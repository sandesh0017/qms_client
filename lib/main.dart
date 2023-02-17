import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qms_client/view/screens/tv_1.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SingleDisplayScreen(),
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
