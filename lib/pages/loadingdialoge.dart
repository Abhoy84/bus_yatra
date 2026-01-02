import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            height: 110,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 176, 206, 213),
                borderRadius: BorderRadius.all(Radius.circular(400))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(
                //   "asset/image/bus2.png",
                //   height: 40,
                //   width: 40,
                // ),
                LottieBuilder.asset("asset/lotti/bus.json", height: 65),
                // CircularProgressIndicator(
                //     valueColor: AlwaysStoppedAnimation(Colors.black)),
                // SizedBox(
                //   height: 0,
                // ),
                const Text(
                  "Loading....",
                  style: TextStyle(color: Color.fromARGB(255, 10, 3, 90)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
