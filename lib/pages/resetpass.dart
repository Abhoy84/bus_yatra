import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/forgetpass.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:ticketbooking/utils/urlpage.dart';

class resetpass extends StatefulWidget {
  const resetpass({super.key});

  @override
  State<resetpass> createState() => _resetpassState();
}

class _resetpassState extends State<resetpass> {
  GlobalKey<FormState> formkey = GlobalKey();
  String newpassword = '';
  bool newpasswordvisibility = false;
  bool confirmpasswordvisibility = false;
  TextEditingController newpasscontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.theamecolor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: C.textfromcolor,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (builder) => const Login()));
          },
        ),
        title: Text(
          "Reset Password".toUpperCase(),
          style: TextStyle(color: C.fromfeildcolor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("asset/image/forgetpass2.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Can't left blank!";
                      } else if (value.length < 6) {
                        return "Contains atleast 6 characters!";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) => newpassword = value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: newpasswordvisibility,
                    obscuringCharacter: "*",
                    controller: newpasscontroller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: C.theamecolor,
                      hintText: "Creat new Password",
                      suffixIcon: TextButton(
                          onPressed: () {
                            newpasswordvisibility = !newpasswordvisibility;
                            setState(() {});
                          },
                          child: newpasswordvisibility
                              ? Icon(
                                  Icons.visibility_off,
                                  color: C.theamecolor,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: C.theamecolor,
                                )),
                      hintStyle: TextStyle(
                        color: C.theamecolor,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      labelText: "Creat new Password",
                      labelStyle: TextStyle(
                        color: C.theamecolor,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: C.theamecolor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: C.theamecolor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: SizedBox(
                  height: 60,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Can't left blank!";
                      } else if (newpassword != value) {
                        return "password does not match";
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: confirmpasswordvisibility,
                    keyboardType: TextInputType.visiblePassword,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.check_box),
                      filled: true,
                      prefixIconColor: C.theamecolor,
                      hintText: "Confirm  Password",
                      suffixIcon: TextButton(
                          onPressed: () {
                            confirmpasswordvisibility =
                                !confirmpasswordvisibility;
                            setState(() {});
                          },
                          child: confirmpasswordvisibility
                              ? Icon(
                                  Icons.visibility_off,
                                  color: C.theamecolor,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: C.theamecolor,
                                )),
                      hintStyle: TextStyle(
                        color: C.theamecolor,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: "Confirm new Password",
                      labelStyle: TextStyle(
                        color: C.theamecolor,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: C.theamecolor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: C.theamecolor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 230,
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: C.theamecolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Text(
                      "UPDATE",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'mogra',
                          color: C.textfromcolor),
                    ),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        changepassword(forgetpassState.emailAddress!,
                            newpasscontroller.text);
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          btnOkColor: Colors.red,
                          headerAnimationLoop: false,
                          showCloseIcon: true,
                          title: 'Incorrect old password!!',
                          desc:
                              "your previous password is incorrect.check again!",
                          btnOkOnPress: () {},
                        ).show();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future changepassword(String email, String pass) async {
    Map data = {'email': email, 'pass': pass};
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var response = await http
          .post(Uri.parse('${MyUrl.fullurl}changepass.php'), body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'true') {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata['msg']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Login()));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata['msg']);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
