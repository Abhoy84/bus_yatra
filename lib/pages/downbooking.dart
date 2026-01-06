import 'package:flutter/src/widgets/framework.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/pages/admindownticket.dart';
import 'package:ticketbooking/pages/adminlogin.dart';

import 'package:ticketbooking/pages/dottedborder.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';

import 'package:ticketbooking/pages/color.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'package:ticketbooking/utils/urlpage.dart';

class downbooking extends StatefulWidget {
  const downbooking({super.key});

  @override
  State<downbooking> createState() => downbookingState();
}

class downbookingState extends State<downbooking> {
  late SharedPreferences sp;
  String uid = '';
  String? viewdate;
  static String showdate = '';
  int count = 0;
  static String? orderid;
  bool search = false;
  // bool allticket = true;
  DateTime currentdate = DateTime.now();
  @override
  void initState() {
    showdate = DateFormat('yMd').format(currentdate);
    // getdata().whenComplete(() {
    //   setState(() {
    Fluttertoast.showToast(msg: showdate);
    //   });
    // });
    super.initState();
  }

  List<Ticket> tickets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (builder) => homepage(use as User)));
          },
          icon: Icon(Icons.home, color: C.textfromcolor),
        ),
        backgroundColor: C.theamecolor,
        title: Text("Booked Tickets", style: TextStyle(color: C.textfromcolor)),
        actions: [
          TextButton(
            onPressed: () {
              search = !search;
              setState(() {});
            },
            child: search == false
                ? const Icon(Icons.search, color: Colors.white, size: 40)
                : const Icon(Icons.search_off, size: 40, color: Colors.white),
          ),
        ],
      ),
      body: search == true
          ? Center(
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Search by Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        DateTime? pickdate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2050),
                        );

                        if (pickdate != null) {
                          viewdate =
                              "  ${DateFormat('yMMMd').format(pickdate)}";
                          showdate = DateFormat('yMd').format(pickdate);
                        } else {
                          viewdate =
                              "  ${DateFormat('yMMMEd').format(currentdate)}";
                          showdate = DateFormat('yMd').format(currentdate);
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 50,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 30),
                            Text(
                              viewdate != null
                                  ? viewdate!
                                  : "Select Your Date here",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        // ignore: sort_child_properties_last
                        child: const Text(
                          'SEARCH TICKETS',
                          style: TextStyle(
                            fontSize: 19,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: C.theamecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          search = false;
                          setState(() {});
                          // if (formkey.currentState!.validate()) {
                          //   sp = await SharedPreferences.getInstance();
                          //   sp.setString('pickuppoint', updepotsearchController.text);
                          //   sp.setString(
                          //       'destination', downdepotsearchController.text);

                          //   setState(() {});

                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) => buslistpage()));
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder(
              future: getbookingListByDate(
                AdminloginState.busid,
                showdate,
                AdminloginState.downdepot,
              ),
              builder: (BuildContext context, AsyncSnapshot data) {
                if (data.hasData) {
                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          orderid = tickets[index].id;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => const admindownticket(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 19, 93, 239),
                                Color.fromARGB(255, 12, 50, 150),

                                Color.fromARGB(255, 4, 18, 63),
                                // Color.fromARGB(255, 110, 142, 14819),
                                // Color.fromARGB(255, 73, 97, 205),
                                // Color.fromARGB(255, 91, 225, 138),

                                // Color.fromARGB(255, 74, 177, 113),
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.2),
                            //     spreadRadius: 2,
                            //     blurRadius: 0,
                            //     offset: Offset(5, 0),
                            //   ),
                            // ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 0,
                                ),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: const Color.fromARGB(
                                        0,
                                        125,
                                        100,
                                        205,
                                      ),
                                      // height: 180,
                                      width: 235,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              top: 5,
                                              bottom: 15,
                                            ),
                                            alignment: Alignment.topLeft,
                                            color: const Color.fromARGB(
                                              0,
                                              215,
                                              10,
                                              10,
                                            ),
                                            child: Text(
                                              "Ticket NO: ${tickets[index].id}",
                                              style: TextStyle(
                                                color: C.textfromcolor,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                            ),
                                            child: Text(
                                              "Id :${tickets[index].userid}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                              bottom: 5,
                                              left: 5,
                                            ),
                                            child: Text(
                                              tickets[index].username
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          // SizedBox(
                                          //   height: 15,
                                          // ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                              bottom: 5,
                                              left: 5,
                                            ),
                                            child: Text(
                                              "No. of Passenger :${stringToSet(tickets[index].seat).length}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 7,
                                            ),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "seat no.: ${tickets[index].seat} "
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(right: ),
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.topLeft,

                                            child: const Text(
                                              "tap to get details",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          // SizedBox(
                                          //   height: 10,
                                          // ),

                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            padding: const EdgeInsets.only(
                                              right: 25,
                                              bottom: 5,
                                            ),
                                            child: Text(
                                              " ${tickets[index].date}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: const Color.fromARGB(0, 16, 7, 45),
                                      child: CustomPaint(
                                        painter: DottedBorderPainter(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.topRight,
                                                padding: const EdgeInsets.only(
                                                  bottom: 18,
                                                  left: 10,
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color.fromARGB(
                                                              255,
                                                              5,
                                                              219,
                                                              44,
                                                            ),
                                                      ),
                                                  child: const Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Container(
                                                alignment: Alignment.topRight,
                                                padding: const EdgeInsets.only(
                                                  bottom: 18,
                                                  left: 10,
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color.fromARGB(
                                                              255,
                                                              219,
                                                              5,
                                                              5,
                                                            ),
                                                      ),
                                                  child: const Text(
                                                    " Absent  ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Positioned(
                                left: 220,
                                top: -25,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                ),
                              ),
                              const Positioned(
                                left: 220,
                                bottom: -25,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: LoadingDialog(),
                    // child: CircularProgressIndicator(
                    //   valueColor: AlwaysStoppedAnimation(
                    //     Color.fromARGB(255, 0, 132, 255),
                    //   ),
                    // ),
                  );
                }
              },
            ),
    );
  }

  Future getbookingListByDate(String busid, String date, String end) async {
    Map data = {"busid": busid, 'date': date, 'start': end};
    try {
      var response = await http.post(
        Uri.parse("${MyUrl.fullurl}getdownbooking.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        tickets.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Ticket ticket = Ticket(
            busname: jsondata['data'][i]['busname'],
            start: jsondata['data'][i]['start'],
            end: jsondata['data'][i]['end'],
            id: jsondata['data'][i]['orderid'],
            seat: jsondata['data'][i]['seatno'].toString(),
            date: jsondata['data'][i]['date'],
            time: jsondata['data'][i]['time'],
            amount: jsondata['data'][i]['amount'],
            status: jsondata['data'][i]['status'],
            username: jsondata['data'][i]['username'],
            busid: jsondata['data'][i]['busid'],
            userid: jsondata['data'][i]['userid'],
          );
          tickets.add(ticket);

          // reg = jsondata['data'][i]['Reg_no'];
          // sp.setString("ticketprice", jsondata['data'][i]['Ticket_price']);
        }
      } else {
        Fluttertoast.showToast(
          // msg: jsondata['msg'],
          msg: 'loading..',
        );
      }
      return tickets;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future getdata() async {
    sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid') ?? '';
    // Fluttertoast.showToast(msg: sp.getString("uid") ?? "");
  }

  Set<int> stringToSet(String inputString) {
    List<String> parts = inputString
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');

    Set<int> result = Set<int>.from(
      parts.map((String value) {
        return int.tryParse(value) ??
            0; // Use 0 as the default value if parsing fails
      }),
    );
    // if (inputString == "none") {
    //   result = {12345};
    // }

    return result;
  }
}
