import 'package:flutter/src/widgets/framework.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/pages/dottedborder.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/color.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'package:ticketbooking/utils/urlpage.dart';

class historyticketlist extends StatefulWidget {
  const historyticketlist({super.key});

  @override
  State<historyticketlist> createState() => historyticketlistState();
}

class historyticketlistState extends State<historyticketlist> {
  late SharedPreferences sp;
  String? uid;
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
          "Ticket History",
          style: TextStyle(color: C.textfromcolor),
        ),
      ),
      body: FutureBuilder(
        future: uid != null ? getTicketList(uid!) : null,
        builder: (BuildContext context, AsyncSnapshot data) {
          if (data.hasData) {
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
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
                            Color.fromARGB(255, 110, 142, 14819),
                            Color.fromARGB(255, 73, 97, 205),
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
                                horizontal: 5.0, vertical: 0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: const Color.fromARGB(0, 125, 100, 205),
                                  // height: 180,
                                  width: 235,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          tickets[index].busname.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
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
                                  color: const Color.fromARGB(0, 16, 7, 45),
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
                                            Icons.check_circle_outline,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            size: 120,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.only(
                                              top: 0, bottom: 10, left: 0),
                                          child: Text(
                                            "!! thank you !!".toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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
          Uri.parse("${MyUrl.fullurl}get_completeticketlist.php"),
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

  Future getdata() async {
    sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid') ?? '';
  }
}
