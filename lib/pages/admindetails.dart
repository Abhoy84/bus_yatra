import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/adminmodel.dart';

import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/utils/urlpage.dart';

// ignore: must_be_immutable
class admindetails extends StatefulWidget {
  Admin admin;
  admindetails(this.admin, {super.key});

  @override
  State<admindetails> createState() => _admindetailsState(admin);
}

class _admindetailsState extends State<admindetails> {
  late SharedPreferences sp;
  Admin admin;
  _admindetailsState(this.admin);
  TextEditingController adminnamecontroller = TextEditingController();
  TextEditingController adminphonecontroller = TextEditingController();
  TextEditingController adminemailcontroller = TextEditingController();
  TextEditingController adminpasscodecontroller = TextEditingController();
  TextEditingController adminconfirmpasscodecontroller =
      TextEditingController();
  String passcode = '';
  String ConfirmPasscode = '';
  @override
  void initState() {
    super.initState();
    adminnamecontroller.text = admin.name;
    adminphonecontroller.text = admin.phone;
    adminemailcontroller.text = admin.email;
    adminpasscodecontroller.text = admin.passcode;
    adminconfirmpasscodecontroller.text = admin.passcode;
  }

  GlobalKey<FormState> formkey = GlobalKey();

  bool nametype = false;
  bool phonetype = false;
  bool emailtype = false;
  bool passcodetype = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: C.textfromcolor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: C.theamecolor,
          centerTitle: true,
          title: Text(
            "Admin Details",
            style: TextStyle(color: C.textfromcolor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 255, left: 20, right: 20),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 233, 230, 230),
                        ),
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 8, left: 10),
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: C.theamecolor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 105, 105, 105)
                                            .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 178),
                                    width: 100,
                                    child: const Text(
                                      "User name",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          enabled: nametype,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          controller: adminnamecontroller,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Cannot left Blank!';
                                            } else {
                                              return null;
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(
                                                0, 255, 255, 255),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.person_2_sharp,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            nametype = !nametype;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 178),
                                    width: 100,
                                    child: const Text(
                                      "Phone no.",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          enabled: phonetype,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          controller: adminphonecontroller,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Cannot left Blank!';
                                            } else {
                                              return null;
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(
                                                0, 255, 255, 255),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.phone_android,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            phonetype = !phonetype;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 178),
                                    width: 100,
                                    child: const Text(
                                      "E-mail",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          enabled: emailtype,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          controller: adminemailcontroller,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Cannot left Blank!';
                                            } else if (!RegExp(
                                                    r'[^0-9]+[a-zA-Z0-9]+@+gmail+\.+com')
                                                .hasMatch(value)) {
                                              return 'Please enter Valide email id';
                                            } else {
                                              return null;
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(
                                                0, 255, 255, 255),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            emailtype = !emailtype;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 178),
                                    width: 100,
                                    child: const Text(
                                      "Passcode",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          enabled: passcodetype,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          controller: adminpasscodecontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return ' Password Requried!';
                                            } else if (value.trim().length <=
                                                3) {
                                              return "Contains atleast 4 numbers";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (value) =>
                                              passcode = value,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(
                                                0, 255, 255, 255),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passcodetype = !passcodetype;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 125),
                                    width: 150,
                                    child: const Text(
                                      "Confirm passcode",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: TextFormField(
                                          enabled: passcodetype,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          controller:
                                              adminconfirmpasscodecontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'field required';
                                            } else if (value !=
                                                adminpasscodecontroller.text) {
                                              return 'Confimation password does not match';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (value) =>
                                              ConfirmPasscode = value,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(
                                                0, 255, 255, 255),
                                            filled: true,
                                            prefixIcon: Icon(
                                              Icons.mobile_friendly,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passcodetype = !passcodetype;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: 140,
                              height: 55,
                              decoration: BoxDecoration(
                                color: C.theamecolor,
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(15),
                                    right: Radius.circular(15)),
                              ),
                              child: TextButton(
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                      color: C.textfromcolor,
                                      fontFamily: "mogra",
                                      fontSize: 29),
                                ),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    adminupdate(
                                            admin.regno,
                                            adminnamecontroller.text,
                                            adminphonecontroller.text,
                                            adminemailcontroller.text,
                                            adminpasscodecontroller.text)
                                        .whenComplete(() {
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please Enter required feilds");
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: C.theamecolor, width: 5),
                            // left: BorderSide(),
                            right: const BorderSide(),
                          ),
                          color: C.theamecolor,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "asset/image/bus48.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 130,
                        child: CircleAvatar(
                          backgroundColor: C.theamecolor,
                          radius: 65,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              "asset/image/bus48.jpg",
                            ),
                            backgroundColor: Colors.black,
                            radius: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> adminupdate(
    String regno,
    String name,
    String phone,
    String email,
    String passcode,
  ) async {
    Map data = {
      "regno": regno,
      "name": name,
      "phone": phone,
      "email": email,
      "passcode": passcode
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http
          .post(Uri.parse("${MyUrl.fullurl}admin_update.php"), body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        sp = await SharedPreferences.getInstance();
        admin.name = adminnamecontroller.text;
        admin.phone = adminphonecontroller.text;
        admin.phone = adminphonecontroller.text;
        admin.passcode = adminpasscodecontroller.text;
        sp.setString('adminname', admin.name);
        sp.setString('adminphone', admin.phone);
        sp.setString('adminemail', admin.email);
        sp.setString('adminpasscode', admin.passcode);
        setState(() {});
        Navigator.pop(context);

        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }
}
