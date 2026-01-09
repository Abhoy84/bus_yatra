import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/pages/admin/Adminsign.dart';
import 'package:ticketbooking/pages/admin/adminhomepage.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:ticketbooking/pages/common/loadingdialoge.dart';
import 'package:ticketbooking/pages/user/forgetpass.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<Adminlogin> createState() => AdminloginState();
}

class AdminloginState extends State<Adminlogin> {
  TextEditingController passcodecontroller = TextEditingController();
  TextEditingController busnocontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  late SharedPreferences sp;
  static String busid = '';
  static String updepot = '';
  static String downdepot = '';
  bool isvisible = false;
  bool type = true;
  Future<void> voidlog(String password, String email) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      // 1. Firebase Auth Login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 2. Fetch Bus/Admin Details from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('buses')
          .doc(uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Admin admin = Admin(
          name: data['name'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          passcode: password,
          busname: data['busname'] ?? '',
          regno: data['regno'] ?? '',
          seatno: data['seatno'].toString(),
          type: data['type'] ?? '',
          updepot: data['updepot'] ?? '',
          uptime: data['uptime'] ?? '',
          uptvtime: data['uptvtime'] ?? '',
          downdepot: data['downdepot'] ?? '',
          downtime: data['downtime'] ?? '',
          downtvtime: data['downtvtime'] ?? '',
          status: data['busstatus'] ?? 'active',
          ticketprice: data['ticketprice'] ?? '',
          busimage: data['busimage'] ?? '',
          statusReason: data['statusReason'] ?? '',
        );

        sp = await SharedPreferences.getInstance();
        // Admin details
        sp.setString('adminname', admin.name);
        sp.setString('adminphone', admin.phone);
        sp.setString('adminemail', admin.email);
        sp.setString('busname', admin.busname);
        sp.setString('busregno', admin.regno);
        sp.setString('busseatno', admin.seatno);
        sp.setString('bustype', admin.type);
        sp.setString('updepot', admin.updepot);
        sp.setString('uptime', admin.uptime);
        sp.setString('uptvtime', admin.uptvtime);
        sp.setString('downdepot', admin.downdepot);
        sp.setString('downtime', admin.downtime);
        sp.setString('downtvtime', admin.downtvtime);
        sp.setString('busstatus', admin.status);
        sp.setString('ticketprice', admin.ticketprice);
        sp.setString('busimage', admin.busimage);

        busid = admin.regno;
        updepot = admin.updepot;
        downdepot = admin.downdepot;

        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Login Successful");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => adminhome(admin)),
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "No Bus details found for this Admin.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.message ?? "Login Failed");
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: C.theamecolor,
        appBar: AppBar(
          title: const Text("Admin Login"),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 0),
                  height: 200,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    child: const Image(
                      image: AssetImage("asset/image/bus51.png"),
                      height: 127,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(95, 130, 124, 124),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              "ADMIN",
                              speed: const Duration(seconds: 1),
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 40,
                                fontFamily: "mogra",
                                fontWeight: FontWeight.bold,
                              ),
                              colors: [
                                const Color.fromARGB(255, 255, 255, 255),
                                const Color.fromARGB(255, 255, 255, 255),
                                const Color.fromARGB(255, 225, 165, 13),
                                const Color.fromARGB(255, 255, 255, 255),
                                Colors.white,
                              ],
                            ),
                          ],
                          pause: const Duration(milliseconds: 100),
                          repeatForever: true,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 39,
                          vertical: 20,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: busnocontroller,
                          // keeping variable name for now to minimize diff, but treated as email
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email required!';
                            } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value)) {
                              return 'Enter valid email.';
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
                            filled: true,
                            hintText: "ENTER EMAIL ID",
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            labelText: " ENTER EMAIL ",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 3,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 39),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passcodecontroller,
                          obscureText: type,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password required!';
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
                            filled: true,
                            hintText: "ENTER PASSWORD",
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            labelText: " PASSWORD ",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            suffixIcon: TextButton(
                              child: type
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: Colors.white,
                                    ),
                              onPressed: () {
                                setState(() {
                                  type = !type;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 3,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 200),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const forgetpass(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forget Passcode? ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 0),
                        height: 60,
                        width: 270,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          // ignore: sort_child_properties_last
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: C.theamecolor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            fixedSize: const Size(300, 50),
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              voidlog(
                                passcodecontroller.text,
                                busnocontroller.text,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please Enter Email id and Password",
                              );
                            }
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 0),
                            margin: const EdgeInsets.only(bottom: 30, left: 85),
                            child: Text(
                              "Dont have any Passcode?",
                              style: TextStyle(
                                fontSize: 10,
                                color: C.textfromcolor,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 30,
                              right: 10,
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AdminSign(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Click",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
