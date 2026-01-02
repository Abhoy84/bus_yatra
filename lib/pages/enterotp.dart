import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/forgetpass.dart';
import 'package:ticketbooking/pages/loadingdialog.dart';
import 'package:email_otp/email_otp.dart';
import 'package:ticketbooking/pages/resetpass.dart';

class enterotp extends StatefulWidget {
  const enterotp({Key? key}) : super(key: key);

  @override
  State<enterotp> createState() => _enterotpState();
}

class _enterotpState extends State<enterotp> {
  EmailOTP myauth = EmailOTP();
  GlobalKey<FormState> formkey = GlobalKey();

  TextEditingController otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:Color.fromARGB(255, 251, 170, 30) ,
      appBar: AppBar(
        iconTheme: IconThemeData(color: C.fromfeildcolor),
        backgroundColor: C.theamecolor,
        title: Text(
          "Enter OTP!",
          style: TextStyle(color: C.fromfeildcolor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "asset/image/forgetpass2.png",
                scale: 1.8,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Center(
                child: Text(
                  "Enter your 4-digit OTP here!",
                  style: TextStyle(
                    fontFamily: "sans-serif",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              child: Form(
                // key: formkey,
                child: TextFormField(
                  controller: otp,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Cannot left Blank!';
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    labelText: "O-T-P",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: "ENTER OTP",
                    prefixIcon: const Icon(
                      Icons.key,
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
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 40,
              ),
              height: 50,
              width: 280,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    'VERIFY',
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: "mogra"),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.theamecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {
                    if (forgetpassState.realotp == otp.text) {
                      showBeautifulLoadingDialog(context).whenComplete(() {
                        Fluttertoast.showToast(msg: "OTP veryfied!!")
                            .whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const resetpass(),
                            ),
                          );
                        });
                      });
                    } else {
                      showBeautifulLoadingDialog(context).whenComplete(
                          // ignore: unnecessary_set_literal
                          () => {Fluttertoast.showToast(msg: "invalid OTP!")});
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
