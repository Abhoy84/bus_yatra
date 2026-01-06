import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticketbooking/models/passenger.dart';
import 'package:ticketbooking/pages/firstticket.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

class passengerlistafter extends StatefulWidget {
  const passengerlistafter({super.key});

  @override
  State<passengerlistafter> createState() => _passengerlistafterState();
}

class _passengerlistafterState extends State<passengerlistafter> {
  List<Pass> passenger = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: C.textfromcolor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Passenger List",
          style: TextStyle(color: C.textfromcolor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: C.theamecolor,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pass>>(
        future: getpassengerlist(ticketafterState.id),
        builder: (BuildContext context, AsyncSnapshot<List<Pass>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: passenger.length,
              itemBuilder: (BuildContext context, int index) {
                final pass = passenger[index];
                final isMale = pass.gender.trim().toLowerCase() == "male";

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMale
                          ? [Colors.blue.shade50, Colors.white]
                          : [Colors.pink.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isMale
                          ? Colors.blue.shade100
                          : Colors.pink.shade100,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMale
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.pink.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Gender Avatar
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: isMale ? Colors.blue : Colors.pink,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isMale
                                    ? Colors.blue.withOpacity(0.4)
                                    : Colors.pink.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            isMale ? Icons.person : Icons.person_2,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pass.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.cake,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${pass.age} Years",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Icon(
                                    isMale ? Icons.male : Icons.female,
                                    size: 16,
                                    color: isMale ? Colors.blue : Colors.pink,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pass.gender,
                                    style: TextStyle(
                                      color: isMale
                                          ? Colors.blue[700]
                                          : Colors.pink[700],
                                      fontWeight: FontWeight.bold,
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
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(
                    "No Passengers Found",
                    style: TextStyle(color: Colors.grey[500], fontSize: 18),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Pass>> getpassengerlist(String orderid) async {
    passenger.clear();
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(orderid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> passengersData = data['passengers'] ?? [];

        for (var p in passengersData) {
          passenger.add(
            Pass(
              name: p['name'] ?? 'Unknown',
              age: p['age'] ?? '0',
              gender: p['gender'] ?? 'Unknown',
              orderid: orderid,
              pid: '', // Not needed for display
            ),
          );
        }
      } else {
        Fluttertoast.showToast(msg: "Booking not found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading passengers: $e");
    }
    return passenger;
  }
}
