import 'package:flutter/material.dart';
import 'package:ticketbooking/models/passenger.dart';
import 'package:ticketbooking/pages/getTicket.dart';
import 'package:ticketbooking/pages/color.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'package:ticketbooking/utils/urlpage.dart';

class passengerlist extends StatefulWidget {
  const passengerlist({super.key});

  @override
  State<passengerlist> createState() => _passengerlistState();
}

class _passengerlistState extends State<passengerlist> {
  List<Pass> passenger = [];
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Passengerlist",
          style: TextStyle(color: C.textfromcolor),
        ),
        backgroundColor: C.theamecolor,
      ),
      body: FutureBuilder(
        future: getpassengerlist(ticketState.id),
        builder: (BuildContext context, AsyncSnapshot data) {
          if (data.hasData) {
            return ListView.builder(
              itemCount: passenger.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          // Color.fromARGB(255, 20, 246, 144),
                          Color.fromARGB(255, 2, 232, 205),
                          Color.fromARGB(255, 20, 28, 246),
                        ],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                color: const Color.fromARGB(0, 251, 0, 67),
                                child: passenger[index].gender.toUpperCase() ==
                                        "MALE"
                                    ? const Icon(
                                        Icons.person_sharp,
                                        size: 100.0,
                                        color:
                                            Color.fromARGB(255, 241, 230, 230),
                                      )
                                    : passenger[index].gender.toUpperCase() ==
                                            "FEMALE"
                                        ? const Icon(
                                            Icons.person_2,
                                            size: 100.0,
                                            color: Color.fromARGB(
                                                255, 241, 230, 230),
                                          )
                                        : const Icon(
                                            Icons.person_4,
                                            size: 100.0,
                                            color: Color.fromARGB(
                                                255, 241, 230, 230),
                                          ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 35, horizontal: 15),
                                color: const Color.fromARGB(0, 16, 7, 45),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      passenger[index].name.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      'Age: ${passenger[index].age}',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 3.0),
                                    Text(
                                      'Gender: ${passenger[index].gender}',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: -20,
                          top: 55,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width - 38,
                          bottom: 50,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Container(
              height: 250,
              width: 350,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Person Icon
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Icon(
                      Icons.person,
                      size: 64.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16.0), // Spacer

                  // Profile Information
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Age: 30',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Gender: Male',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future getpassengerlist(String orderid) async {
    Map data = {"orderid": orderid};
    try {
      var response = await http
          .post(Uri.parse("${MyUrl.fullurl}get_passenger.php"), body: data);
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        passenger.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Pass pass = Pass(
              name: jsondata['data'][i]['name'],
              age: jsondata['data'][i]['age'],
              gender: jsondata['data'][i]['gender'],
              orderid: jsondata['data'][i]['order_id'],
              pid: jsondata['data'][i]['pass_id']);
          passenger.add(pass);

          // reg = jsondata['data'][i]['Reg_no'];
          // sp.setString("ticketprice", jsondata['data'][i]['Ticket_price']);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return passenger;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }
}
