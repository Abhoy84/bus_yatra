import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:http/http.dart' as http;
import 'package:ticketbooking/pages/seatinfo.dart';
import 'package:ticketbooking/utils/urlpage.dart';

import 'package:flutter/src/widgets/framework.dart';

class manageSeat extends StatefulWidget {
  const manageSeat({super.key});

  @override
  State<manageSeat> createState() => manageSeatState();
}

class manageSeatState extends State<manageSeat> with TickerProviderStateMixin {
  late SharedPreferences sp;

  Set<int> tappedContainers = <int>{};
  Map<String, Set> seatlist = <String, Set>{};
  late AnimationController _controller;
  Color containerColor = Colors.indigo;
  String? Regno;

  void swaping() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void initState() {
    regno();

    swaping(); // TODO: implement initState
    super.initState();
  }

  void regno() async {
    sp = await SharedPreferences.getInstance();
    Regno = sp.getString("busregno");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: C.textfromcolor),
        backgroundColor: C.theamecolor,
        title: Text(
          "Seat manage ",
          style: TextStyle(color: C.textfromcolor),
        ),
        actions: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: InkWell(
              onTap: () {
                _controller.forward().whenComplete(() {
                  setState(() {
                    tappedContainers.clear();
                    swaping();
                  });
                });
              },
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                radius: 20,
                child: Icon(
                  Icons.refresh,
                  size: 32,
                  color: Color.fromARGB(255, 234, 234, 234),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
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
                        crossAxisCount:
                            SeatinfoState.column + 1, // Number of columns
                      ),
                      itemCount: (SeatinfoState.column + 1) *
                          SeatinfoState.row, // 10 rows x 5 columns = 50 items
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            setState(() {
                              tappedContainers.add(index);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 50,
                            height: 40,
                            decoration: BoxDecoration(
                              color: tappedContainers.contains(index)
                                  ? Colors.transparent
                                  : containerColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),

                    // // Container(child: MyApp(),)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        seatlist[Regno!] = tappedContainers;
                        saveinfo(
                            Regno!,
                            SeatinfoState.row.toString(),
                            SeatinfoState.column.toString(),
                            tappedContainers.toString());
                      },
                      child: const Text("save"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveinfo(
      String regno, String row, String column, String inactive) async {
    Map data = {
      "regno": regno,
      "row": row,
      "column": column,
      "inactive": inactive
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http
          .post(Uri.parse("${MyUrl.fullurl}seatinfo_insert.php"), body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata["msg"]);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata["msg"]);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }
}
