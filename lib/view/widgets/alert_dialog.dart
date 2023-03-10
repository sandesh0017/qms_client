import 'package:flutter/material.dart';

import '../../core/local/shared_prefence.dart';
import '../screens/configure_screen.dart';

Future<dynamic> logOutOnPress(BuildContext context) {
  return showDialog(
      context: context,
      builder: (n) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ConfigureScreen()));
                SessionPreferences().clearSession();
              },
              child: const Text('Yes'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            )
          ],
        );
      });
}
