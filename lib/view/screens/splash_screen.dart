import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qms_client/models/user_session_model.dart';
import 'package:qms_client/view/screens/configure_screen.dart';
import 'package:qms_client/view/screens/service_offered_screen.dart';

import '../../core/local/shared_prefence.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _checkSession() async {
    UserSession? sessionData = await SessionPreferences().getSession();
    if (sessionData != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ServiceOfferedScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ConfigureScreen()));
    }
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      _checkSession();
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
          width: deviceWidth * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/qms_splash_icon.png',
                // width: deviceWidth * 0.1,
                height: deviceHeight * 0.2,
              ),
              // const SizedBox(height: 20),
              Container(
                color: Colors.greenAccent,
                child: Image.asset(
                  'assets/images/q1.png',
                  fit: BoxFit.fill,
                  width: deviceWidth * 0.75,
                  height: deviceHeight * 0.3,
                ),
              ),
              // const Text(
              //   'QMS',
              //   style: TextStyle(
              //     fontSize: 50,
              //   ),
              // ),
              Container(
                // color: Colors.green,
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  // width: deviceWidth * 0.2,
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
