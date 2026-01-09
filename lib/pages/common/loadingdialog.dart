import 'dart:async';
import 'package:flutter/material.dart';

Future<void> showBeautifulLoadingDialog(BuildContext context) async {
  // Show the dialog
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevents dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return const AlertDialog(
        backgroundColor: Color.fromARGB(0, 100, 100, 100),
        shadowColor: Colors.transparent,
        // surfaceTintColor: Colors.transparent,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(), // You can customize the loading indicator
            SizedBox(height: 16.0),
            Text("Loading..."), // Customize the loading message
          ],
        ),
      );
    },
  );

  // Delay for 3 seconds
  await Future.delayed(const Duration(seconds: 2));

  // Close the dialog
  Navigator.of(context).pop();
}
