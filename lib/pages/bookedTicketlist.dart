import 'package:flutter/src/widgets/framework.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/dottedborder.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/getTicket.dart';
import 'package:ticketbooking/pages/color.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'package:ticketbooking/utils/urlpage.dart';

class bookedticketlist extends StatefulWidget {
  const bookedticketlist({super.key});

  @override
  State<bookedticketlist> createState() => bookedticketlistState();
}

class bookedticketlistState extends State<bookedticketlist> {
  User? use;
  late SharedPreferences sp;
  String uid = '';
  String? viewdate;
  static String? showdate;
  int count = 0;
  static String? orderid;
  bool search = false;
  bool allticket = true;
  DateTime currentdate = DateTime.now();
  @override
  void initState() {
    getdata().whenComplete(() {
      setState(() {});
    });
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
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.home,
            color: C.textfromcolor,
          ),
        ),
        backgroundColor: C.theamecolor,
        title: Text(
          "Booked Tickets",
          style: TextStyle(color: C.textfromcolor),
        ),
        actions: [
          TextButton(
              onPressed: () {
                search = !search;
                setState(() {});
              },
              child: search == false
                  ? const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 40,
                    )
                  : const Icon(
                      Icons.search_off,
                      size: 40,
                      color: Colors.white,
                    ))
        ],
      ),
      body: search == true
          ? Center(
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Search by Date",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime? pickdate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2050));

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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 30,
                            ),
                            Text(
                              viewdate != null
                                  ? viewdate!
                                  : "Select Your Date here",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                          setState(() {
                            allticket = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder(
              future: allticket == true
                  ? getTicketList(uid)
                  : getTicketListByDate(uid, showdate!),
              builder: (BuildContext context, AsyncSnapshot data) {
                if (data.hasData) {
                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          orderid = tickets[index].id;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => const ticket()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          // height: 210,
                          margin: const EdgeInsets.only(
                            top: 0,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(0, 227, 17, 17),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  // Color.fromARGB(255, 110, 142, 14819),
                                  // Color.fromARGB(255, 73, 97, 205),
                                  Color.fromARGB(255, 91, 225, 138),

                                  Color.fromARGB(255, 74, 177, 113),
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
                                      horizontal: 5.0, vertical: 0),
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: const Color.fromARGB(
                                            0, 125, 100, 205),
                                        // height: 180,
                                        width: 235,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 5, bottom: 15),
                                              alignment: Alignment.topLeft,
                                              color: const Color.fromARGB(
                                                  0, 215, 10, 10),
                                              child: Text(
                                                "Ticket NO: ${tickets[index].id}",
                                                style: TextStyle(
                                                    color: C.textfromcolor,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topCenter,
                                              padding: const EdgeInsets.only(
                                                  bottom: 20, left: 5),
                                              child: Text(
                                                "!! happy journey !!"
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 15,
                                            // ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, left: 5),
                                              child: Text(
                                                tickets[index].start,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, left: 7),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "to ".toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.only(
                                                  bottom: 18, left: 5),
                                              child: Text(
                                                tickets[index].end,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 20,
                                            // ),
                                            Container(
                                              alignment: Alignment.topRight,
                                              padding: const EdgeInsets.only(
                                                  right: 25, bottom: 5),
                                              child: Text(
                                                " ${tickets[index].date}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color:
                                            const Color.fromARGB(0, 16, 7, 45),
                                        child: CustomPaint(
                                          painter: DottedBorderPainter(),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.only(
                                                    bottom: 18, left: 10),
                                                child: const Icon(
                                                  Icons
                                                      .directions_bus_filled_outlined,
                                                  color: Colors.white,
                                                  size: 120,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 10,
                                                    left: 0),
                                                child: Text(
                                                  tickets[index]
                                                      .busname
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
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
                                )
                              ],
                            ),
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

  Future getTicketList(String userid) async {
    Map data = {"userid": userid};
    try {
      var response = await http.post(
          Uri.parse("${MyUrl.fullurl}get_bookedticketlist.php"),
          body: data);
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        tickets.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Ticket ticket = Ticket(
              busname: jsondata['data'][i]['busname'],
              start: jsondata['data'][i]['start'],
              end: jsondata['data'][i]['end'],
              id: jsondata['data'][i]['orderid'],
              seat: jsondata['data'][i]['seatno'],
              date: jsondata['data'][i]['date'],
              time: jsondata['data'][i]['time'],
              amount: jsondata['data'][i]['amount'],
              status: jsondata['data'][i]['status'],
              username: jsondata['data'][i]['username'],
              busid: jsondata['data'][i]['busid'],
              userid: jsondata['data'][i]['userid']);
          tickets.add(ticket);

          // reg = jsondata['data'][i]['Reg_no'];
          // sp.setString("ticketprice", jsondata['data'][i]['Ticket_price']);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return tickets;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future getTicketListByDate(String userid, String date) async {
    Map data = {"userid": userid, 'date': date};
    try {
      var response = await http.post(
          Uri.parse("${MyUrl.fullurl}get_datebookticket.php"),
          body: data);
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        tickets.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Ticket ticket = Ticket(
              busname: jsondata['data'][i]['busname'],
              start: jsondata['data'][i]['start'],
              end: jsondata['data'][i]['end'],
              id: jsondata['data'][i]['orderid'],
              seat: jsondata['data'][i]['seatno'],
              date: jsondata['data'][i]['date'],
              time: jsondata['data'][i]['time'],
              amount: jsondata['data'][i]['amount'],
              status: jsondata['data'][i]['status'],
              username: jsondata['data'][i]['username'],
              busid: jsondata['data'][i]['busid'],
              userid: jsondata['data'][i]['userid']);
          tickets.add(ticket);
        }
      } else {
        Fluttertoast.showToast(
          msg: 'loading..',
        );
      }
      return tickets;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future getdata() async {
    sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid') ?? '';
  }
}
