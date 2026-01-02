import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/seatmodel.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/utils/urlpage.dart';

// ignore: must_be_immutable
class adminseatselection extends StatefulWidget {
  Seat seat;
  adminseatselection(this.seat, {super.key});

  @override
  State<adminseatselection> createState() => _adminseatselectionState(seat);
}

class _adminseatselectionState extends State<adminseatselection>
    with TickerProviderStateMixin {
  Seat seat;
  _adminseatselectionState(this.seat);

  Color containerColor = const Color.fromARGB(255, 100, 102, 102);
  late SharedPreferences sp;
  int row = 0;
  int column = 0;
  String inactive = '';
  String? Regno;
  Set? seatinfo;
  void swaping() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void initState() {
    setState(() {
      swaping();
      saveinformation();
      regno();
    });
    // TODO: implement initState
    super.initState();
  }

  void saveinformation() {
    row = int.parse(seat.row);
    column = int.parse(seat.column);
    inactive = seat.inactive;
    seatinfo = stringToSet(inactive);
    // Fluttertoast.showToast(msg: seatinfo.toString());
  }

  late AnimationController _controller;

  void regno() async {
    sp = await SharedPreferences.getInstance();
    Regno = sp.getString("busregno");
  }

  @override
  Widget build(BuildContext context) {
    // matchValue();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.theamecolor,
        title: const Text('Manage Seat'),
        centerTitle: true,
        actions: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: InkWell(
              onTap: () {
                _controller.forward().whenComplete(() {
                  setState(() {
                    seatinfo!.clear();
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
      body: Padding(
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
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 42, 41, 40),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  const Text(
                    "long press on seat icon to arrang!",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    // width: 100,
                    height: 40,
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(255, 221, 4, 4),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ElevatedButton(
                        onPressed: () {
                          saveinfo(Regno!, seatinfo.toString());
                        },
                        child: const Text("update")),
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
                      itemCount:
                          (column + 1) * row, // 10 rows x 5 columns = 50 items
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            setState(() {
                              seatinfo!.add(index);
                            });
                          },
                          child: Image(
                            image: const AssetImage(
                              "asset/image/backseat.png",
                            ),
                            height: 60,
                            width: 60,
                            color: seatinfo!.contains(index)
                                ? Colors.transparent
                                : containerColor,
                          ),
                        );
                      },
                    ),

                    // // Container(child: MyApp(),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<int> stringToSet(String inputString) {
    List<String> parts =
        inputString.replaceAll('{', '').replaceAll('}', '').split(',');

    Set<int> result = Set<int>.from(parts.map((String value) {
      return int.tryParse(value) ?? 0;
    }));

    return result;
  }

  Future<void> saveinfo(String regno, String inactive) async {
    Map data = {"regno": regno, "inactive": inactive};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http
          .post(Uri.parse("${MyUrl.fullurl}seatinfo_update.php"), body: data);
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
