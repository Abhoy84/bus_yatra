import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/seatmodel.dart';
import 'package:ticketbooking/pages/getTicket.dart';
import 'package:ticketbooking/pages/addpassenger.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/color.dart';

import 'package:ticketbooking/utils/urlpage.dart';

// ignore: must_be_immutable
class seatselection extends StatefulWidget {
  Seat seat;
  seatselection(this.seat, {super.key});

  @override
  State<seatselection> createState() => seatselectionState(seat);
}

class seatselectionState extends State<seatselection> {
  Seat seat;
  seatselectionState(this.seat);

  Color containerColor = const Color.fromARGB(255, 100, 102, 102);
  Color reservedcontainerColor = const Color.fromRGBO(217, 20, 20, 1);
  Color selectedcontainerColor = const Color.fromARGB(255, 2, 255, 52);
  late SharedPreferences sp;
  int row = 0;
  String? uid;

  String? date;
  String? busno;
  int column = 0;
  String inactive = '';
  String user = '';
  String total = '';
  Set active = {};
  String? Regno;
  Set? seatinfo;
  Set userselected = {};
  Set totalreserved = {};
  int max = 0;
  static int total_amount = 0;
  static String orderid = '';
  static Set seatno = {};

  Set<int> selectedseat = <int>{};
  @override
  void initState() {
    setState(() {
      regno().whenComplete(() {
        setState(() {});
      });
    });
    // TODO: implement initState
    super.initState();
  }

  Future regno() async {
    row = int.parse(seat.row);
    column = int.parse(seat.column);
    inactive = seat.inactive;
    user = seat.userslected;
    total = seat.totalreserved;
    userselected = stringToSet(user);
    totalreserved = stringToSet(total);
    seatinfo = stringToSet(inactive);
    sp = await SharedPreferences.getInstance();
    date = homepageState.showdate!;
    uid = sp.getString('uid');
    busno = buslistpageState.reg;
  }

  @override
  Widget build(BuildContext context) {
    // matchValue();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: C.textfromcolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: C.theamecolor,
        title: Text(
          'select Seat',
          style: TextStyle(color: C.textfromcolor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.width / 12,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 109, 111, 111),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    const Text(
                      "available",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.width / 12,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 3, 247, 19),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    const Text(
                      "Selected",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.width / 12,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 221, 4, 4),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    const Text(
                      "Reserved",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 35,
                            child: Image.asset(
                              "asset/image/driver.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 0, 0, 0),
                        thickness: 3,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: column + 1 // Number of columns
                            ),
                        itemCount: (column + 1) *
                            row, // 10 rows x 5 columns = 50 items
                        itemBuilder: (context, index) {
                          if (seatinfo!.contains(index) == false) {
                            active.add(index);
                          }

                          return InkWell(
                            onTap: seatinfo!.contains(index) ||
                                    totalreserved.contains(index)
                                ? null
                                : () {
                                    if (user == "none") {
                                      if (selectedseat.contains(index)) {
                                        selectedseat.remove(index);

                                        max = 0;
                                        setState(() {});
                                      } else if (selectedseat.length < 6) {
                                        selectedseat.add(index);
                                      } else if (selectedseat.length == 6) {
                                        max = 1;
                                      }
                                      setState(() {
                                        if (max == 1) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Maximum 6 seats are allowed!!");
                                        }
                                      });
                                    }
                                  },
                            child: Image(
                                image: const AssetImage(
                                  "asset/image/backseat.png",
                                ),
                                color: seatinfo!.contains(index)
                                    ? Colors.transparent
                                    : userselected.contains(index)
                                        ? selectedcontainerColor
                                        : totalreserved.contains(index)
                                            ? reservedcontainerColor
                                            : selectedseat.contains(index)
                                                ? selectedcontainerColor
                                                : containerColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                user == 'none'
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromRGBO(255, 255, 255, 1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 74, 73, 73)
                                  .withOpacity(0.7),
                              spreadRadius: 5,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width - 20,
                        child: Column(
                          children: [
                            Text(
                              "Seat numbers:-${setToString(
                                findIndex(active, selectedseat),
                              )}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Total amount:-${totalamount(selectedseat.length)}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: C.theamecolor,
                              ),
                              width: MediaQuery.of(context).size.width - 20,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: C.theamecolor),
                                onPressed: () {
                                  if (selectedseat.isNotEmpty) {
                                    bookingInsert(
                                            date!,
                                            uid!,
                                            busno!,
                                            selectedseat.toString(),
                                            findIndex(active, selectedseat)
                                                .toString(),
                                            buslistpageState.From)
                                        // ignore: unnecessary_set_literal
                                        .whenComplete(() => {
                                              seatno = selectedseat,
                                              getid(
                                                  date!,
                                                  uid!,
                                                  selectedseat.toString(),
                                                  busno!,
                                                  buslistpageState.From)
                                            });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Seat not selected!");
                                  }
                                },
                                child: Text(
                                  "Proceed to Pay",
                                  style: TextStyle(
                                      color: C.textfromcolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: C.theamecolor,
                        ),
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: C.theamecolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => const ticket()));
                          },
                          child: Text(
                            "View Ticket",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: C.textfromcolor),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<int> stringToSet(String inputString) {
    List<String> parts = inputString
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');

    Set<int> result = Set<int>.from(parts.map((String value) {
      return int.tryParse(value) ??
          0; // Use 0 as the default value if parsing fails
    }));
    if (inputString == "none") {
      result = {12345};
    }

    return result;
  }

  String setToString(List<int> inputSet) {
    // List<int> setList = inputSet.toList();

    String result = inputSet.join(', ');

    return result;
  }

  String setToString2(Set<int> inputSet) {
    // List<int> setList = inputSet.toList();

    String result = inputSet.join(', ');

    return result;
  }

  int totalamount(int size) {
    int total = 0;
    while (size != 0) {
      total = total + int.parse(buslistpageState.busprice);
      size--;
    }
    total_amount = total;
    return total;
  }

  List<int> findIndex(Set s1, Set<int> s2) {
    List<int> indices = [];

    for (var element in s2) {
      if (s1.contains(element)) {
        int index = s1.toList().indexOf(element) + 1;
        indices.add(index);
      }
    }

    return indices;
  }

  Future bookingInsert(String date, String userid, String regno, String seatno,
      String seat, String updepot) async {
    Map data = {
      'date': date,
      'pid': userid,
      'regno': regno,
      'seatno': seatno,
      'seat': seat,
      'updepot': updepot
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var respond = await http
          .post(Uri.parse("${MyUrl.fullurl}booking_info.php"), body: data);
      var jsondata = jsonDecode(respond.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        // Navigator.of(context).push(
        //     MaterialPageRoute(
        //         builder: (builder) =>
        //             ticket()));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata['msg']);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getid(String date, String pid, String seatno, String regno,
      String updepot) async {
    Map data = {
      "date": date,
      "regno": regno,
      "pid": pid,
      "seatno": seatno,
      "updepot": updepot,
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });

    try {
      var respond = await http
          .post(Uri.parse("${MyUrl.fullurl}get_orderid.php"), body: data);
      var jsondata = jsonDecode(respond.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        orderid = jsondata['id'];

        // seatno = selectedseat;
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const addpassenger()));
        // Navigator.of(context).push(
        //     MaterialPageRoute(
        //         builder: (builder) =>
        //             ticket()));
        // Fluttertoast.showToast(msg: jsondata['msg']);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata['msg']);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
