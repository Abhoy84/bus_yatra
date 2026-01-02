import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/controller/app_controller.dart';

import 'package:ticketbooking/pages/adminbookingdetails.dart';
import 'package:ticketbooking/pages/adminseat.dart';
import 'package:ticketbooking/pages/busdetails.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/pages/admindetails.dart';

import 'package:ticketbooking/pages/login.dart';

// ignore: must_be_immutable
class adminhome extends StatefulWidget {
  Admin admin;
  adminhome(this.admin, {super.key});

  @override
  State<adminhome> createState() => _adminhomeState(admin);
}

class _adminhomeState extends State<adminhome> {
  Admin admin;
  _adminhomeState(this.admin);

  @override
  void initState() {
    super.initState();
  }

  late SharedPreferences sp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.theamecolor,
        title: Text("Bus Owner", style: TextStyle(color: C.textfromcolor)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Logout!',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    content: const Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No', style: TextStyle(fontSize: 17)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => busdetails(admin),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: C.textfromcolor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            105,
                            105,
                            105,
                          ).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: C.theamecolor, width: 5),
                    ),
                    child: Image.asset(
                      "asset/image/busdetails3.png",
                      color: const Color.fromARGB(255, 6, 127, 171),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => const bookingdtails(),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: C.textfromcolor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            105,
                            105,
                            105,
                          ).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: C.theamecolor, width: 5),
                    ),
                    child: Image.asset("asset/image/booking2.png"),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => admindetails(admin),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: C.textfromcolor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            105,
                            105,
                            105,
                          ).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: C.theamecolor, width: 5),
                    ),
                    child: Image.asset("asset/image/admin.png", scale: 3.5),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.333333333333333,
                  height: MediaQuery.of(context).size.width / 13.33333333333333,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => busdetails(admin),
                        ),
                      );
                    },
                    child: const Text(
                      "Bus Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 127, 171),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 3.33333333333333,
                  height: MediaQuery.of(context).size.width / 12.5,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => busdetails(admin),
                        ),
                      );
                    },
                    child: const Text(
                      "Booking Details",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 127, 171),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 3.33333333333333,
                  height: MediaQuery.of(context).size.width / 13.33333333333333,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(223, 30, 30, 0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => admindetails(admin),
                        ),
                      );
                    },
                    child: const Text(
                      "Admin Details",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 127, 171),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                  ),
                ),
                const SizedBox(width: 40),
                InkWell(
                  onTap: () {
                    takeseatinfo(
                      admin.regno,
                      '12/12/2020',
                      '1111',
                      admin.updepot,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: C.textfromcolor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            105,
                            105,
                            105,
                          ).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: C.theamecolor, width: 5),
                    ),
                    child: Image.asset(
                      "asset/image/seat.png",
                      fit: BoxFit.fitHeight,
                      color: const Color.fromARGB(255, 6, 127, 171),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => admindetails(admin),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 4,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.33333333333333,
                  height: MediaQuery.of(context).size.width / 11.42857142857143,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "            ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 127, 171),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: MediaQuery.of(context).size.width / 3.3333333333333,
                  height: MediaQuery.of(context).size.width / 11.42857142857143,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Manage Seat ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 127, 171),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 3.3333333333333,
                  height: MediaQuery.of(context).size.width / 11.42857142857143,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(223, 30, 30, 0),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "          ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 127, 171),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takeseatinfo(
    String regno,
    String date,
    String pid,
    String updepot,
  ) async {
    // Ideally we pass busId (uid) here. Assuming 'regno' might be used or we need the actual document ID.
    // NOTE: In AdminLogin, we fetched the doc by UID. We should probably pass UID.
    // However, looking at AdminLogin, it seems 'regno' is NOT the uid.
    // BUT, the document was fetched with `uid`.
    // The previous implementation used 'regno' for PHP.
    // For Firestore, we need the DOCUMENT ID (which is the User UID).
    // The Admin object doesn't seem to store the raw UID...
    // Wait, in AdminLogin: `String uid = userCredential.user!.uid;` -> `doc(uid).get()`.
    // The logic creates the document with the SAME UID.
    // BUT the Admin object passed to this page doesn't have a 'uid' field.
    // I NEED TO PASS THE UID.
    // For now, I will assume the user is logged in via Firebase Auth, so I can get the UID from there!

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Fluttertoast.showToast(msg: "Error: Not logged in");
        return;
      }
      String busId = user.uid;

      // Get Controller
      final AppController controller = Get.put(AppController());

      // Load Data
      await controller.loadSeatLayout(busId);

      // Navigate
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminSeatSelection(busId: busId),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
