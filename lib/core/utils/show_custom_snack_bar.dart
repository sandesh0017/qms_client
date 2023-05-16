import 'package:flutter/material.dart';

showCustomSnackBar(BuildContext context, String msg,
    {bool taskSuccess = true}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: taskSuccess == true
            ? Colors.black.withOpacity(0.7)
            : Colors.red.withOpacity(0.7),
        width: MediaQuery.of(context).size.width / 1.4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 30),
      ),
    );
}
