import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/adminlogin.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/forgetpass.dart';
import 'package:ticketbooking/pages/sign.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/pages/adminhomepage.dart';
import 'package:ticketbooking/pages/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey();
  bool isvisible = false;
  bool type = true;

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getvalue();
  }

  late SharedPreferences sp;
  Future<void> voidlog(String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      // Sign in with Firebase Auth
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        User user = User(
          email: userData['email'] ?? email,
          fname: userData['fname'] ?? '',
          phone: userData['phone'] ?? '',
          uid: uid,
          image: userData['image'] ?? '',
        );

        sp = await SharedPreferences.getInstance();
        sp.setString('email', user.email);
        sp.setString('fname', user.fname);
        sp.setString('phone', user.phone);
        sp.setString('uid', user.uid);
        sp.setString('image', user.image);

        Navigator.pop(context); // Close dialog
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homepage(user)),
        );
        Fluttertoast.showToast(msg: "Login Successful");
      } else {
        Navigator.pop(context);
        await auth.FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(msg: "User record not found in database");
      }
    } on auth.FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.message ?? "Login Failed");
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building Login Page UI..."); // DEBUG LOG
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).unfocus();
      }),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: C.theamecolor,
          body: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 0),

                    // ignore: sort_child_properties_last
                    child: const CircleAvatar(
                      radius: 65,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      child: Image(
                        image: AssetImage("asset/image/login2.png"),
                        height: 127,
                      ),
                    ),
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(95, 130, 124, 124),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),

                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //   color: C.theamecolor,
                      // borderRadius: const BorderRadius.only(
                      //     topLeft: Radius.circular(60),
                      //     topRight: Radius.circular(60)),
                      // ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            margin: const EdgeInsets.only(bottom: 0),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  "LOGIN",
                                  speed: const Duration(seconds: 1),
                                  textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 40,
                                    fontFamily: "mogra",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: [
                                    const Color.fromARGB(255, 255, 255, 255),
                                    const Color.fromARGB(255, 225, 165, 13),
                                    Colors.white,
                                  ],
                                ),
                              ],
                              pause: const Duration(milliseconds: 100),
                              repeatForever: true,
                            ),
                            // child: Text(
                            //   "LOGIN",
                            //   style: TextStyle(
                            //     fontSize: 40,
                            //     fontWeight: FontWeight.bold,
                            //     fontFamily: "mogra",
                            //     color: Color.fromARGB(255, 255, 255, 255),
                            //   ),
                            // ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 39,
                              vertical: 25,
                            ),
                            child: TextFormField(
                              controller: useremailcontroller,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Can't left blank";
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 3,
                                  ),
                                ),
                                fillColor: const Color.fromARGB(
                                  0,
                                  255,
                                  255,
                                  255,
                                ),
                                filled: true,
                                hintText: "e-mail id",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                labelText: "E-MAIL ID ",
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 39),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: passwordcontroller,
                              obscureText: type,
                              obscuringCharacter: '*',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password required!';
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                fillColor: const Color.fromARGB(
                                  0,
                                  255,
                                  255,
                                  255,
                                ),
                                filled: true,
                                hintText: "Enter Password",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                labelText: " PASSWORD ",
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.key,
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
                                "Forget Password? ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 0),
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
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  voidlog(
                                    useremailcontroller.text,
                                    passwordcontroller.text,
                                  );
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool(
                                    SplashscreenState.KEYLOGIN,
                                    true,
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
                                margin: const EdgeInsets.only(
                                  bottom: 30,
                                  left: 85,
                                ),
                                child: Text(
                                  "Are you an Bus provider?",
                                  style: TextStyle(
                                    fontSize: 12,
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
                                  onPressed: () async {
                                    // Check if user is already logged in
                                    if (auth
                                            .FirebaseAuth
                                            .instance
                                            .currentUser !=
                                        null) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return const LoadingDialog();
                                        },
                                      );

                                      try {
                                        String uid = auth
                                            .FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid;
                                        DocumentSnapshot doc =
                                            await FirebaseFirestore.instance
                                                .collection('buses')
                                                .doc(uid)
                                                .get();

                                        if (doc.exists) {
                                          Map<String, dynamic> data =
                                              doc.data()
                                                  as Map<String, dynamic>;

                                          Admin admin = Admin(
                                            name: data['name'] ?? '',
                                            phone: data['phone'] ?? '',
                                            email: data['email'] ?? '',
                                            passcode: data['passcode'] ?? '',
                                            busname: data['busname'] ?? '',
                                            regno: data['regno'] ?? '',
                                            seatno: data['seatno'].toString(),
                                            type: data['type'] ?? '',
                                            updepot: data['updepot'] ?? '',
                                            uptime: data['uptime'] ?? '',
                                            uptvtime: data['uptvtime'] ?? '',
                                            downdepot: data['downdepot'] ?? '',
                                            downtime: data['downtime'] ?? '',
                                            downtvtime:
                                                data['downtvtime'] ?? '',
                                            status:
                                                data['busstatus'] ?? 'active',
                                            ticketprice:
                                                data['ticketprice'] ?? '',
                                            busimage: data['busimage'] ?? '',
                                          );

                                          Navigator.pop(
                                            context,
                                          ); // Close dialog
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  adminhome(admin),
                                            ),
                                          );
                                        } else {
                                          Navigator.pop(
                                            context,
                                          ); // Close dialog
                                          // Logged in user is not an admin, proceed to Admin Login page
                                          // Consider if we should sign out current user?
                                          // For now, just go to Admin Login, which handles its own auth.
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Adminlogin(),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                          msg:
                                              "Error checking login status ${e.toString()}",
                                        );
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Adminlogin(),
                                          ),
                                        );
                                      }
                                    } else {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Adminlogin(),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "click",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        TextButton(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
