import 'dart:convert';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbooking/models/busmodel.dart';
import 'package:ticketbooking/models/seatmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/dottedborder.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/seatselection.dart';

class buslistpage extends StatefulWidget {
  const buslistpage({super.key});

  @override
  State<buslistpage> createState() => buslistpageState();
}

class buslistpageState extends State<buslistpage> {
  static String busprice = '';
  static String reg = '';
  late SharedPreferences sp;
  String? date;
  String? pid;
  static String From = '';
  static String To = '';
  static String time = '';

  static String busname = '';
  static String bookid = '';
  List<Bus> buslist = [];
  User? user;
  Future<List<Bus>> getorderrequests(String from, String to) async {
    try {
      // Query Firestore for buses matching route
      // Note: This assumes simple direct route matching.
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('buses')
          .where('updepot', isEqualTo: from)
          .where('downdepot', isEqualTo: to)
          .get();

      // If no direct Up_depot match, check reverse (Down_depot == from, Up_depot == to)?
      // For now implementing strict match based on existing logic structure

      buslist.clear();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          Bus bus = Bus(
            data['busname'] ?? '',
            data['regno'] ?? '',
            data['seatno'] ?? '',
            data['type'] ?? '',
            data['updepot'] ?? '',
            data['uptime'] ?? '',
            data['uptvtime'] ?? '',
            data['downdepot'] ?? '',
            data['downtime'] ?? '',
            data['downtvtime'] ?? '',
            data['busstatus'] ?? 'active',
            data['ticketprice'] ?? '',
            data['busimage'] ?? '',
          );
          buslist.add(bus);
          // Store ticket price if needed (logic from original code)
          sp.setString("ticketprice", data['ticketprice'] ?? '');
        }
      } else {
        // Try querying for reverse route or other conditions if needed
        // For now, returning empty list or handle as 'No buses found'
      }
      return buslist;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  Future setdata() async {
    sp = await SharedPreferences.getInstance();
    From = sp.getString("pickuppoint") ?? "";

    To = sp.getString("destination") ?? "";
    pid = sp.getString("uid") ?? "";
    date = homepageState.showdate;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata().whenComplete(() {
      setState(() {
        getUser().whenComplete(() {
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: C.textfromcolor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: C.theamecolor,
          title: Text(
            "Avalible Buses",
            style: TextStyle(color: C.textfromcolor),
          ),
        ),
        body: FutureBuilder(
          future: getorderrequests(From, To),
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              return ListView.builder(
                itemCount: buslist.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      takesetinfo(
                        buslist[index].Reg_no,
                        pid!,
                        date!,
                        From,
                      ).whenComplete(() {
                        reg = buslist[index].Reg_no;
                        busprice = buslist[index].Ticket_price;
                        time =
                            buslist[index].Up_depot.toUpperCase() ==
                                From.toUpperCase()
                            ? buslist[index].Up_time
                            : buslist[index].Down_time;
                        busname = buslist[index].Bus_name;
                      });
                      //heCD llo
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 210,
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(0, 227, 17, 17),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              C.theamecolor,
                              const Color.fromARGB(255, 8, 4, 125),

                              // Color.fromARGB(255, 24, 210, 198),
                              // Color.fromARGB(255, 47, 128, 237)
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: const Color.fromARGB(
                                      0,
                                      125,
                                      100,
                                      205,
                                    ),
                                    height: 180,
                                    width: 125,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.transparent,
                                          width: 110,
                                          height: 90,
                                          child: Image.asset(
                                            "asset/image/busdetails3.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: 0,
                                            left: 5,
                                          ),
                                          child: Text(
                                            buslist[index].Bus_name
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          child: Text(
                                            "Reg.no: \n${buslist[index].Reg_no}"
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: const Color.fromARGB(0, 16, 7, 45),
                                    height: 180,
                                    width: 225,
                                    child: CustomPaint(
                                      painter: DottedBorderPainter(),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              bottom: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  buslist[index].Type,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "₹${buslist[index].Ticket_price} ",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              bottom: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                buslist[index].Up_depot
                                                            .toUpperCase() ==
                                                        From.toUpperCase()
                                                    ? Text(
                                                        "Time: ${buslist[index].Up_time}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      )
                                                    : Text(
                                                        "Time: ${buslist[index].Down_time}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Duration: ${buslist[index].Up_travel_time}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                buslist[index].Up_depot
                                                            .toUpperCase() ==
                                                        From.toUpperCase()
                                                    ? Column(
                                                        children: [
                                                          Text(
                                                            "From: ${buslist[index].Up_depot}",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                          Text(
                                                            "To: ${buslist[index].Down_depot} ",
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          Text(
                                                            "Form: ${buslist[index].Down_depot}",
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                          Text(
                                                            "TO: ${buslist[index].Up_depot} ",
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
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
                                ],
                              ),
                            ),
                            const Positioned(
                              left: 110,
                              top: -25,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                              ),
                            ),
                            const Positioned(
                              left: 110,
                              bottom: -25,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: LoadingDialog());
            }
          },
        ),
      ),
    );
  }

  Future takesetinfo(
    String regno,
    String pid,
    String date,
    String updepot,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      // Migration: Simplified logic using defaults.
      Seat seat = Seat(
        row: "10",
        column: "4",
        inactive: "",
        userslected: "none",
        totalreserved: "none",
      );

      sp = await SharedPreferences.getInstance();
      sp.setString('seatrow', "10");
      sp.setString('seatcolumn', "4");
      sp.setString("userselected", "none");
      sp.setString("totalreserved", "none");

      sp.setString('inactive', "").whenComplete(() {
        takeorderid(regno, pid, date, From).whenComplete(() {
          Navigator.pop(context); // Pop dialog
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => seatselection(seat)));
        });
      });
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> takeorderid(
    String regno,
    String pid,
    String date,
    String updepot,
  ) async {
    // Migration: Generating local order ID.
    // In a real app, this might be a Firestore document creation.
    bookid = DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future getUser() async {
    sp = await SharedPreferences.getInstance();

    String email = sp.getString('email') ?? "";
    String fname = sp.getString('fname') ?? "";
    String phone = sp.getString('phone') ?? "";
    String uid = sp.getString('uid') ?? "";
    String image = sp.getString('image') ?? "";

    user = User(
      email: email,
      fname: fname,
      phone: phone,
      uid: uid,
      image: image,
    );
  }
}
