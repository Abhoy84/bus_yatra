import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/payment.dart';
import 'package:ticketbooking/pages/seatselection.dart';
import 'package:http/http.dart' as http;
import 'package:ticketbooking/utils/urlpage.dart';

class addpassenger extends StatefulWidget {
  const addpassenger({super.key});

  @override
  State<addpassenger> createState() => _addpassengerState();
}

class _addpassengerState extends State<addpassenger> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController p1 = TextEditingController();
  TextEditingController p2 = TextEditingController();
  TextEditingController p3 = TextEditingController();
  TextEditingController p4 = TextEditingController();
  TextEditingController p5 = TextEditingController();
  TextEditingController p6 = TextEditingController();

  TextEditingController p1name = TextEditingController();
  TextEditingController p2name = TextEditingController();
  TextEditingController p3name = TextEditingController();
  TextEditingController p4name = TextEditingController();
  TextEditingController p5name = TextEditingController();
  TextEditingController p6name = TextEditingController();

  String genderbuttonp1 = 'Male';
  String genderbuttonp2 = 'Male';
  String genderbuttonp3 = 'Male';
  String genderbuttonp4 = 'Male';
  String genderbuttonp5 = 'Male';
  String genderbuttonp6 = 'Male';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
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
          title: Text(
            "Passenger Details",
            style: TextStyle(color: C.textfromcolor),
          ),
          backgroundColor: C.theamecolor,
        ),
        body: Form(
          key: formkey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: seatselectionState.seatno.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == seatselectionState.seatno.length) {
                      return Container(
                          width: 200,
                          height: 60,
                          decoration: const BoxDecoration(),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const LoadingDialog();
                                  },
                                );
                                if (seatselectionState.seatno.length == 1) {
                                  passengerDetailsInsert(
                                          p1name.text,
                                          p1.text,
                                          seatselectionState.orderid,
                                          genderbuttonp1)
                                      .whenComplete(() =>
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (builder) =>
                                                  const Payment(),
                                            ),
                                          ));
                                } else if (seatselectionState.seatno.length ==
                                    2) {
                                  passengerDetailsInsert(
                                          p1name.text,
                                          p1.text,
                                          seatselectionState.orderid,
                                          genderbuttonp1)
                                      .whenComplete(() {
                                    passengerDetailsInsert(
                                            p2name.text,
                                            p2.text,
                                            seatselectionState.orderid,
                                            genderbuttonp2)
                                        .whenComplete(() =>
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (builder) =>
                                                    const Payment(),
                                              ),
                                            ));
                                  });
                                } else if (seatselectionState.seatno.length ==
                                    3) {
                                  passengerDetailsInsert(
                                          p1name.text,
                                          p1.text,
                                          seatselectionState.orderid,
                                          genderbuttonp1)
                                      .whenComplete(() {
                                    passengerDetailsInsert(
                                            p2name.text,
                                            p2.text,
                                            seatselectionState.orderid,
                                            genderbuttonp2)
                                        .whenComplete(() {
                                      passengerDetailsInsert(
                                              p3name.text,
                                              p3.text,
                                              seatselectionState.orderid,
                                              genderbuttonp3)
                                          .whenComplete(() =>
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (builder) =>
                                                      const Payment(),
                                                ),
                                              ));
                                    });
                                  });
                                } else if (seatselectionState.seatno.length ==
                                    4) {
                                  passengerDetailsInsert(
                                          p1name.text,
                                          p1.text,
                                          seatselectionState.orderid,
                                          genderbuttonp1)
                                      .whenComplete(() {
                                    passengerDetailsInsert(
                                            p2name.text,
                                            p2.text,
                                            seatselectionState.orderid,
                                            genderbuttonp2)
                                        .whenComplete(() {
                                      passengerDetailsInsert(
                                              p3name.text,
                                              p3.text,
                                              seatselectionState.orderid,
                                              genderbuttonp3)
                                          .whenComplete(() {
                                        passengerDetailsInsert(
                                                p4name.text,
                                                p4.text,
                                                seatselectionState.orderid,
                                                genderbuttonp4)
                                            .whenComplete(() =>
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const Payment(),
                                                  ),
                                                ));
                                      });
                                    });
                                  });
                                } else if (seatselectionState.seatno.length ==
                                    5) {
                                  passengerDetailsInsert(
                                          p1name.text,
                                          p1.text,
                                          seatselectionState.orderid,
                                          genderbuttonp1)
                                      .whenComplete(() {
                                    passengerDetailsInsert(
                                            p2name.text,
                                            p2.text,
                                            seatselectionState.orderid,
                                            genderbuttonp2)
                                        .whenComplete(() {
                                      passengerDetailsInsert(
                                              p3name.text,
                                              p3.text,
                                              seatselectionState.orderid,
                                              genderbuttonp3)
                                          .whenComplete(() {
                                        passengerDetailsInsert(
                                                p4name.text,
                                                p4.text,
                                                seatselectionState.orderid,
                                                genderbuttonp4)
                                            .whenComplete(() {
                                          passengerDetailsInsert(
                                                  p5name.text,
                                                  p5.text,
                                                  seatselectionState.orderid,
                                                  genderbuttonp5)
                                              .whenComplete(() =>
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (builder) =>
                                                          const Payment(),
                                                    ),
                                                  ));
                                        });
                                      });
                                    });
                                  });
                                } else if (seatselectionState.seatno.length ==
                                    6) {
                                  passengerDetailsInsert(
                                          p1name.text,
                                          p1.text,
                                          seatselectionState.orderid,
                                          genderbuttonp1)
                                      .whenComplete(() {
                                    passengerDetailsInsert(
                                            p2name.text,
                                            p2.text,
                                            seatselectionState.orderid,
                                            genderbuttonp2)
                                        .whenComplete(() {
                                      passengerDetailsInsert(
                                              p3name.text,
                                              p3.text,
                                              seatselectionState.orderid,
                                              genderbuttonp3)
                                          .whenComplete(() {
                                        passengerDetailsInsert(
                                                p4name.text,
                                                p4.text,
                                                seatselectionState.orderid,
                                                genderbuttonp4)
                                            .whenComplete(() {
                                          passengerDetailsInsert(
                                                  p5name.text,
                                                  p5.text,
                                                  seatselectionState.orderid,
                                                  genderbuttonp5)
                                              .whenComplete(() {
                                            passengerDetailsInsert(
                                                    p6name.text,
                                                    p6.text,
                                                    seatselectionState.orderid,
                                                    genderbuttonp6)
                                                .whenComplete(() =>
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (builder) =>
                                                            const Payment(),
                                                      ),
                                                    ));
                                          });
                                        });
                                      });
                                    });
                                  });
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please Enter name  and age");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 15, 1, 1),
                              fixedSize: const Size(
                                300,
                                50,
                              ),
                            ),
                            child: Text(
                              "Procced to Next",
                              style: TextStyle(
                                  fontSize: 20, color: C.textfromcolor),
                            ),
                          ));
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width - 10,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromARGB(255, 255, 255, 255)
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "Passenger-${index + 1}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: C.theamecolor),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Name required!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: index == 0
                                      ? p1name
                                      : index == 1
                                          ? p2name
                                          : index == 2
                                              ? p3name
                                              : index == 3
                                                  ? p4name
                                                  : index == 4
                                                      ? p5name
                                                      : p6name,
                                  decoration: const InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 208, 14, 14))),
                                      hintStyle: TextStyle(color: Colors.blue),
                                      hintText: "Enter full name"),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'age required!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: index == 0
                                      ? p1
                                      : index == 1
                                          ? p2
                                          : index == 2
                                              ? p3
                                              : index == 3
                                                  ? p4
                                                  : index == 4
                                                      ? p5
                                                      : p6,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 208, 14, 14))),
                                      hintStyle: TextStyle(color: Colors.blue),
                                      hintText: "Enter Age"),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        width: 20,
                                        child: Radio(
                                          fillColor:
                                              WidgetStateColor.resolveWith(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return const Color.fromARGB(
                                                    255, 22, 13, 13);
                                              }
                                              return const Color.fromARGB(
                                                  255, 0, 0, 0);
                                            },
                                          ),
                                          value: "Male",
                                          groupValue: index == 0
                                              ? genderbuttonp1
                                              : index == 1
                                                  ? genderbuttonp2
                                                  : index == 2
                                                      ? genderbuttonp3
                                                      : index == 3
                                                          ? genderbuttonp4
                                                          : index == 4
                                                              ? genderbuttonp5
                                                              : genderbuttonp6,
                                          onChanged: (value) {
                                            setState(() {
                                              index == 0
                                                  ? genderbuttonp1 =
                                                      value.toString()
                                                  : index == 1
                                                      ? genderbuttonp2 =
                                                          value.toString()
                                                      : index == 2
                                                          ? genderbuttonp3 =
                                                              value.toString()
                                                          : index == 3
                                                              ? genderbuttonp4 =
                                                                  value
                                                                      .toString()
                                                              : index == 4
                                                                  ? genderbuttonp5 =
                                                                      value
                                                                          .toString()
                                                                  : genderbuttonp6 =
                                                                      value
                                                                          .toString();
                                            });
                                          },
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 0),
                                      width: 55,
                                      child: Text(
                                        "Male",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.036,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        width: 10,
                                        color: Colors.white,
                                        child: Radio(
                                          fillColor:
                                              WidgetStateColor.resolveWith(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return const Color.fromARGB(
                                                    255, 0, 0, 0);
                                              }
                                              return const Color.fromARGB(
                                                  255, 0, 0, 0);
                                            },
                                          ),
                                          value: "Female",
                                          groupValue: index == 0
                                              ? genderbuttonp1
                                              : index == 1
                                                  ? genderbuttonp2
                                                  : index == 2
                                                      ? genderbuttonp3
                                                      : index == 3
                                                          ? genderbuttonp4
                                                          : index == 4
                                                              ? genderbuttonp5
                                                              : genderbuttonp6,
                                          onChanged: (value) {
                                            setState(() {
                                              index == 0
                                                  ? genderbuttonp1 =
                                                      value.toString()
                                                  : index == 1
                                                      ? genderbuttonp2 =
                                                          value.toString()
                                                      : index == 2
                                                          ? genderbuttonp3 =
                                                              value.toString()
                                                          : index == 3
                                                              ? genderbuttonp4 =
                                                                  value
                                                                      .toString()
                                                              : index == 4
                                                                  ? genderbuttonp5 =
                                                                      value
                                                                          .toString()
                                                                  : genderbuttonp6 =
                                                                      value
                                                                          .toString();
                                            });
                                          },
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 0),
                                      width: 70,
                                      color: Colors.white,
                                      child: Text(
                                        "Female",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.036,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        width: 10,
                                        color: Colors.white,
                                        child: Radio(
                                          fillColor:
                                              WidgetStateColor.resolveWith(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return const Color.fromARGB(
                                                    255, 0, 0, 0);
                                              }
                                              return const Color.fromARGB(
                                                  255, 0, 0, 0);
                                            },
                                          ),
                                          value: "Other",
                                          groupValue: index == 0
                                              ? genderbuttonp1
                                              : index == 1
                                                  ? genderbuttonp2
                                                  : index == 2
                                                      ? genderbuttonp3
                                                      : index == 3
                                                          ? genderbuttonp4
                                                          : index == 4
                                                              ? genderbuttonp5
                                                              : genderbuttonp6,
                                          onChanged: (value) {
                                            setState(() {
                                              index == 0
                                                  ? genderbuttonp1 =
                                                      value.toString()
                                                  : index == 1
                                                      ? genderbuttonp2 =
                                                          value.toString()
                                                      : index == 2
                                                          ? genderbuttonp3 =
                                                              value.toString()
                                                          : index == 3
                                                              ? genderbuttonp4 =
                                                                  value
                                                                      .toString()
                                                              : index == 4
                                                                  ? genderbuttonp5 =
                                                                      value
                                                                          .toString()
                                                                  : genderbuttonp6 =
                                                                      value
                                                                          .toString();
                                            });
                                          },
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 0),
                                      width: 70,
                                      color: Colors.white,
                                      child: Text(
                                        "Other",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.036,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future passengerDetailsInsert(
      String name, String age, String orderid, String gender) async {
    Map data = {'name': name, 'age': age, 'gender': gender, 'orderid': orderid};
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var respond = await http
          .post(Uri.parse("${MyUrl.fullurl}passenger_insert.php"), body: data);
      var jsondata = jsonDecode(respond.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
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
