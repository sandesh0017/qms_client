import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qms_client/core/constants/api_endpoints.dart';
import 'package:qms_client/core/local/set_session.dart';
import 'package:qms_client/view/screens/configure_screen.dart';
import 'package:qms_client/view/screens/service_offered_screen.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/local/storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _checkSession() async {
    // UserSession? sessionData = await SessionPreferences().getSession();
    SetSess? sessionData = await HiveHelper().getSessionHive();
    if (sessionData != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          windowManager.waitUntilReadyToShow().then((_) async {
            windowManager.maximize();

            await windowManager.show();
          });
          return const ServiceOfferedScreen();
        }),
        (route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          windowManager.waitUntilReadyToShow().then((_) async {
            windowManager.maximize();
            await windowManager.show();
          });

          return const ConfigureScreen();
        }),
        (route) => false,
      );
    }
  }

  _checkBaseUrl() async {
    // String? baseUrl = await SessionPreferences().getBaseUrl();
    String? baseUrl = await HiveHelper().getBaseUrl();

    if (baseUrl != null) {
      ApiUrl.baseUrl = baseUrl;
    }
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      _checkSession();
      _checkBaseUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: SizedBox(
          width: deviceWidth * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/qms_splash_icon.png',
                width: deviceWidth * 0.2,
                height: deviceHeight * 0.2,
              ),
              const SizedBox(height: 40),
              Container(
                width: deviceWidth * 0.3,
                height: deviceHeight * 0.3,
                constraints: const BoxConstraints(minWidth: 350),
                child: Image.asset(
                  filterQuality: FilterQuality.high,
                  'assets/images/q1.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  height: deviceHeight * 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
