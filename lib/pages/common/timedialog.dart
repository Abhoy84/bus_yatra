import 'package:flutter/material.dart';

class LoadingDialog2 {
  static Future<void> showLoadingDialog(
      BuildContext context, Duration duration) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 100,
            height: 100,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(duration);
    Navigator.of(context)
        .pop(); // Close the dialog after the specified duration.
  }
}
