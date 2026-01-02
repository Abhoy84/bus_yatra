import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/color.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:ticketbooking/pages/passengerlistafter.dart';

import 'package:http/http.dart' as http;
import 'package:ticketbooking/utils/urlpage.dart';
import 'package:ticketbooking/pages/seatselection.dart';

class ticketafter extends StatefulWidget {
  const ticketafter({super.key});

  @override
  State<ticketafter> createState() => ticketafterState();
}

class ticketafterState extends State<ticketafter> {
  double space = 40.0;
  String busname = '';
  String start = '';
  String end = '';
  String time = '';
  String date = '';
  String amount = '';
  static String id = '';
  String seat = '';
  String status = '';
  String orderid = '';
  @override
  void initState() {
    // Fluttertoast.showToast(msg: seatselectionState.orderid);

    getTicketDetails(seatselectionState.orderid).whenComplete(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const buslistpage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: C.textfromcolor,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (builder) => const buslistpage()));
            },
          ),
          backgroundColor: C.theamecolor,
          title: Text(
            "Ticket",
            style: TextStyle(color: C.textfromcolor),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                id != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 8, left: 10),

                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        // height: 650,
                        // width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 168, 205, 251),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 239, 166, 235),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 105, 105, 105)
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              // ignore: prefer_const_constructors.
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'BOOKING ID: $id',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            // bus number
                            // bus number

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 265,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    busname.toUpperCase(),
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // bus type
                            // bus type
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    "Start form:",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    start,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    "To:",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    end,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  width: 185,
                                  child: const Text(
                                    "Journey Date:",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  width: 80,
                                  child: const Text(
                                    "Time",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    date,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    time,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  width: 185,
                                  child: const Text(
                                    "Reserved seat no.",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    "Paid Amount",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  width: 185,
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    seat,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "₹$amount",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: space,
                                ),
                                Container(
                                  width: 190,
                                  padding: const EdgeInsets.only(
                                      bottom: 10, right: 70),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: C.theamecolor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  const passengerlistafter()));
                                    },
                                    child: const Text("Passsenger list",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 10)),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromARGB(255, 8, 187, 23),
                                  ),
                                  height: 30,
                                  padding: const EdgeInsets.all(7),
                                  child: const Text("Confirmed!",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 100),
                        width: 350,
                        color: const Color.fromARGB(0, 7, 28, 255),
                        height: 400,
                        child: Image.asset(
                          "asset/image/noticket.png",
                          fit: BoxFit.fill,
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getTicketDetails(String orderid) async {
    Map data = {"orderid": orderid};

    try {
      var response = await http.post(
          // Uri.https( MyUrl.mainurl,MyUrl.suburl+ "student_login.php"),
          Uri.parse("${MyUrl.fullurl}get_ticket.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        // ignore: unused_local_variable
        Ticket ticket = Ticket(
            busname: jsondata["busname"],
            start: jsondata["start"],
            end: jsondata["end"],
            time: jsondata["time"],
            date: jsondata["date"],
            amount: jsondata["amount"],
            id: jsondata["id"],
            seat: jsondata["seat"],
            status: jsondata['booking_status'],
            username: jsondata['username'],
            busid: jsondata['busid'],
            userid: jsondata['userid']);

        busname = jsondata["busname"];
        start = jsondata["start"];
        end = jsondata["end"];
        time = jsondata["time"];
        date = jsondata["date"];
        amount = jsondata["amount"];
        id = jsondata["id"];
        seat = jsondata["seat"];
        status = jsondata['booking_status'];

        // sp = await SharedPreferences.getInstance();
        // sp.setString('email', jsondata['email']);
        // sp.setString('fname', jsondata['fname']);
        // sp.setString('phone', jsondata['phone']);
        // sp.setString('uid', jsondata['uid']);
        // sp.setString('image', jsondata['image']);

        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }
}
