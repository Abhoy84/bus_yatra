import 'dart:async';
import 'package:flutter/material.dart';
// import 'dart:f0fi';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/color.dart';
// import 'package:ticketbooking/pages/example.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/login.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/pages/login2.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late SharedPreferences sharedpref;
  // ignore: unused_field
  late AnimationController _controller;
  static const KEYLOGIN = 'loginkey';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    nextpage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              color: C.theamecolor,
              child: Padding(
                padding: const EdgeInsets.all(130.0),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  child: Image.asset("asset/image/buslogo2.png", scale: 3),
                ),
              ),
              // child: Container(
              //   width: 200,

              //   // nextScreen: Login(),
              //
              // ),
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: C.theamecolor,
              child: const Center(
                child: Text(
                  "Version:1.0.0",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextpage() async {
    sharedpref = await SharedPreferences.getInstance();
    var isloggedin = sharedpref.getBool(KEYLOGIN);
    // Fluttertoast.showToast(msg: isloggedin.toString());

    String email = sharedpref.getString('email') ?? "";
    String fname = sharedpref.getString('fname') ?? "";
    String phone = sharedpref.getString('phone') ?? "";
    String uid = sharedpref.getString('uid') ?? "";
    String image = sharedpref.getString('image') ?? "";

    User user = User(
      email: email,
      fname: fname,
      phone: phone,
      uid: uid,
      image: image,
    );

    String adminemail = sharedpref.getString('adminemail') ?? "";
    String adminname = sharedpref.getString('adminname') ?? "";
    String adminphone = sharedpref.getString('adminphone') ?? "";
    String adminpasscode = sharedpref.getString('adminpasscode') ?? "";
    String busname = sharedpref.getString('busname') ?? "";
    String busregno = sharedpref.getString('busregno') ?? "";
    String seatno = sharedpref.getString('busseatno') ?? "";
    String type = sharedpref.getString('bustype') ?? "";
    String updepot = sharedpref.getString('updepot') ?? "";
    String uptime = sharedpref.getString('uptime') ?? "";
    String uptvtime = sharedpref.getString('uptvtime') ?? "";
    String downdepot = sharedpref.getString('downdepot') ?? "";
    String downtime = sharedpref.getString('downtime') ?? "";
    String downtvtime = sharedpref.getString('downtvtime') ?? "";
    String status = sharedpref.getString('status') ?? "";
    String ticketprice = sharedpref.getString('ticketprice') ?? "";
    String busimage = sharedpref.getString('busimage') ?? "";
    // ignore: unused_local_variable
    Admin admin = Admin(
      name: adminname,
      phone: adminphone,
      passcode: adminpasscode,
      email: adminemail,
      busname: busname,
      regno: busregno,
      seatno: seatno,
      type: type,
      updepot: updepot,
      uptime: uptime,
      uptvtime: uptvtime,
      downdepot: downdepot,
      downtime: downtime,
      downtvtime: downtvtime,
      status: status,
      ticketprice: ticketprice,
      busimage: busimage,
    );

    // String seatrow = sharedpref.getString('seatrow') ?? "";
    // String seatcolumn = sharedpref.getString('seatcolumn') ?? "";
    // String inactive = sharedpref.getString('inactive') ?? "";
    // String userselected = sharedpref.getString('userselected') ?? "";

    // Seat seat = Seat(row: seatrow, column: seatcolumn, inactive: inactive);

    Timer(const Duration(seconds: 1), () {
      print("DEBUG: Timer Finished. Checking login status...");
      if (isloggedin != null) {
        if (isloggedin) {
          print("DEBUG: User logged in. Going to Home.");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => homepage(user)),
          );
          // Center(
          //   child: CircularProgressIndicator(),
          // );
        } else {
          print("DEBUG: User NOT logged in. Going to Login.");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      } else {
        print("DEBUG: Login status is NULL. Going to Login.");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }
}
