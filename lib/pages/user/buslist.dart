import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbooking/models/busmodel.dart';
import 'package:ticketbooking/models/seatmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/user/homepage.dart';
import 'package:ticketbooking/pages/common/color.dart';

import 'package:ticketbooking/pages/common/loadingdialoge.dart';
import 'package:ticketbooking/pages/user/seatselection.dart';

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
  static String travelTime = ''; // Added travelTime
  List<Bus> buslist = [];
  User? user;
  Future<List<Bus>> getorderrequests(String from, String to) async {
    try {
      // Query 1: Check UP Route (From -> To matches Up -> Down)
      QuerySnapshot upSnapshot = await FirebaseFirestore.instance
          .collection('buses')
          .where('updepot', isEqualTo: from)
          .where('downdepot', isEqualTo: to)
          .get();

      print("DEBUG: Searching for From: '$from', To: '$to'");
      print("DEBUG: Timestamp Date: '${homepageState.showdate}'");
      print("DEBUG: UpSnapshot Docs: ${upSnapshot.docs.length}");

      // Query 2: Check DOWN Route (From -> To matches Down -> Up)
      QuerySnapshot downSnapshot = await FirebaseFirestore.instance
          .collection('buses')
          .where('downdepot', isEqualTo: from)
          .where('updepot', isEqualTo: to)
          .get();

      print("DEBUG: DownSnapshot Docs: ${downSnapshot.docs.length}");

      buslist.clear();
      Set<String> addedBusIds = {};

      // Helper function to add buses
      void addBuses(QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          print("DEBUG: Processing Bus ID: ${doc.id}");
          if (addedBusIds.contains(doc.id)) {
            print("DEBUG: Bus already added, skipping.");
            continue;
          }

          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // --- 2-Hour Validation Logic ---
          try {
            // Deduce Departure Time
            String departureTimeStr = '';
            String up = data['updepot'] ?? '';
            String down =
                data['downdepot'] ?? ''; // Use local var to avoid confusion

            // Check against the 'from' argument passed to getorderrequests
            if (up.toLowerCase() == from.toLowerCase()) {
              departureTimeStr = data['uptime'] ?? '';
              print("DEBUG: Direction UP. Departure Time: $departureTimeStr");
            } else if (down.toLowerCase() == from.toLowerCase()) {
              departureTimeStr = data['downtime'] ?? '';
              print("DEBUG: Direction DOWN. Departure Time: $departureTimeStr");
            }

            if (departureTimeStr.isNotEmpty && homepageState.showdate != null) {
              String dateStr = homepageState.showdate!.trim();
              DateFormat dateFormat = DateFormat('M/d/y');
              DateTime busDate = dateFormat.parse(dateStr);
              print("DEBUG: Parsed Bus Date: $busDate");

              DateTime fullDeparture;
              try {
                // Try 12-hour format first (e.g., "10:30 AM")
                DateFormat timeFormat = DateFormat("h:mm a");
                DateTime timePart = timeFormat.parse(departureTimeStr);
                fullDeparture = DateTime(
                  busDate.year,
                  busDate.month,
                  busDate.day,
                  timePart.hour,
                  timePart.minute,
                );
              } catch (_) {
                // Fallback to 24-hour format (e.g., "14:30")
                DateFormat timeFormat = DateFormat("HH:mm");
                DateTime timePart = timeFormat.parse(departureTimeStr);
                fullDeparture = DateTime(
                  busDate.year,
                  busDate.month,
                  busDate.day,
                  timePart.hour,
                  timePart.minute,
                );
              }
              print("DEBUG: Full Departure DateTime: $fullDeparture");
              print("DEBUG: Current DateTime: ${DateTime.now()}");

              // Check 2-hour buffer
              Duration diff = fullDeparture.difference(DateTime.now());
              print("DEBUG: Time Difference (mins): ${diff.inMinutes}");

              if (diff.inMinutes < 120) {
                print("DEBUG: Bus skipped (Less than 120 mins).");
                continue; // Skip bus as it departs in < 2 hours or passed
              } else {
                print("DEBUG: Bus VALID.");
              }
            } else {
              print(
                "DEBUG: Missing Time or Date info. DepTime: '$departureTimeStr', ShowDate: '${homepageState.showdate}'",
              );
            }
          } catch (e) {
            print("ERROR validating bus time: $e");
          }
          // -------------------------------
          Bus bus = Bus(
            data['busname'] ?? '',
            data['regno'] ?? '',
            data['seatno'].toString(),
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
          addedBusIds.add(doc.id);

          // Store ticket price (legacy logic, specific to first found?)
          if (buslist.length == 1) {
            sp.setString("ticketprice", data['ticketprice'] ?? '');
          }
        }
      }

      addBuses(upSnapshot);
      addBuses(downSnapshot);
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
              if (buslist.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_bus_filled_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No Buses Found",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Try searching for a different date or route.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: buslist.length,
                itemBuilder: (BuildContext context, int index) {
                  // Helper function for first word
                  String getFirstWord(String input) {
                    if (input.isEmpty) return "";
                    return input.split(' ')[0];
                  }

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
                        // Set Travel Time based on direction
                        travelTime =
                            buslist[index].Up_depot.toUpperCase() ==
                                From.toUpperCase()
                            ? buslist[index].Up_travel_time
                            : buslist[index].Down_travel_time;

                        busname = buslist[index].Bus_name;
                      });
                    },
                    child: Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          // Gradient Background for Attractive Look
                          gradient: LinearGradient(
                            colors: [
                              C.theamecolor,
                              Colors
                                  .purple
                                  .shade700, // Complementary vibrant color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header: Bus Name and Type
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buslist[index].Bus_name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        buslist[index].Type.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Price Tag
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "₹${buslist[index].Ticket_price}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: C.theamecolor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Divider(
                                color: Colors.white54,
                                thickness: 1,
                              ),
                            ),

                            // Route Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Departure
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buslist[index].Up_depot.toUpperCase() ==
                                              From.toUpperCase()
                                          ? buslist[index].Up_time
                                          : buslist[index].Down_time,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      getFirstWord(
                                        buslist[index].Up_depot.toUpperCase() ==
                                                From.toUpperCase()
                                            ? buslist[index].Up_depot
                                            : buslist[index].Down_depot,
                                      ).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                // Arrow & Duration
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.arrow_right_alt_rounded,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                    Text(
                                      buslist[index].Up_depot.toUpperCase() ==
                                              From.toUpperCase()
                                          ? buslist[index].Up_travel_time
                                          : buslist[index].Down_travel_time,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),

                                // Arrival
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      buslist[index].Up_depot.toUpperCase() ==
                                              From.toUpperCase()
                                          ? buslist[index].Down_time
                                          : buslist[index].Up_time,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      getFirstWord(
                                        buslist[index].Up_depot.toUpperCase() ==
                                                From.toUpperCase()
                                            ? buslist[index].Down_depot
                                            : buslist[index].Up_depot,
                                      ).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
