import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';

class forgetpass extends StatefulWidget {
  const forgetpass({super.key});

  @override
  State<forgetpass> createState() => forgetpassState();
}

class forgetpassState extends State<forgetpass> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController Emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor:Color.fromARGB(255, 251, 170, 30) ,
        appBar: AppBar(
          iconTheme: IconThemeData(color: C.fromfeildcolor),
          backgroundColor: C.theamecolor,
          title: Text(
            "Forget Password!",
            style: TextStyle(color: C.fromfeildcolor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset("asset/image/forgetpass2.png", scale: 1.8),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Center(
                  child: Text(
                    "Enter your registered E-mail id",
                    style: TextStyle(
                      fontFamily: "sans-serif",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    controller: Emailcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot left Blank!';
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return 'Please enter Valid email id';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      labelText: "e-Mail Id",
                      labelStyle: const TextStyle(color: Colors.black),
                      hintText: "ENTER E-MALI",
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                height: 50,
                width: 280,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    'SEND RESET LINK',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: "mogra",
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.theamecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const LoadingDialog();
                        },
                      );

                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: Emailcontroller.text.trim(),
                        );

                        Navigator.pop(context); // Close loading dialog
                        Fluttertoast.showToast(
                          msg: "Reset link sent! Check your email.",
                        );
                        Navigator.pop(context); // Go back to Login
                      } on FirebaseAuthException catch (e) {
                        Navigator.pop(context); // Close loading dialog
                        Fluttertoast.showToast(
                          msg: e.message ?? "Error sending reset email",
                        );
                      } catch (e) {
                        Navigator.pop(context); // Close loading dialog
                        Fluttertoast.showToast(msg: "An error occurred");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
