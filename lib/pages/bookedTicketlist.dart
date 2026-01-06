import 'package:flutter/src/widgets/framework.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/dottedborder.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';

import 'package:ticketbooking/pages/firstticket.dart';
import 'package:ticketbooking/pages/color.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingDialog());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 100),
                      width: 350,
                      height: 400,
                      child: Image.asset(
                        "asset/image/noticket.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }

                tickets.clear();
                for (var doc in snapshot.data!.docs) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  // Handle seatLabels which might be a List
                  String seatStr = "";
                  if (data['seatLabels'] is List) {
                    seatStr = (data['seatLabels'] as List).join(',');
                  } else {
                    seatStr = data['seatLabels'].toString();
                  }

                  // Handle totalPrice
                  String amountStr = data['totalPrice'].toString();

                  Ticket ticket = Ticket(
                    busname: data['busName'] ?? '',
                    start: data['from'] ?? '',
                    end: data['to'] ?? '',
                    id: doc.id,
                    seat: seatStr,
                    date: data['date'] ?? '',
                    time: data['time'] ?? '',
                    amount: amountStr,
                    status:
                        data['status'] ??
                        'confirmed', // utilizing status if present
                    username: '', // Not strictly needed for list view usually
                    busid: data['busId'] ?? '',
                    userid: data['userId'] ?? '',
                    timestamp: data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate()
                        : null,
                  );
                  tickets.add(ticket);
                }

                // Client-side sorting to avoid Firestore Index requirement
                tickets.sort((a, b) {
                  if (a.timestamp == null && b.timestamp == null) return 0;
                  if (a.timestamp == null) return 1;
                  if (b.timestamp == null) return -1;
                  return b.timestamp!.compareTo(a.timestamp!);
                });

                return ListView.builder(
                  itemCount: tickets.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemBuilder: (BuildContext context, int index) {
                    // Helper to get first word
                    String firstWord(String input) {
                      return input.isNotEmpty ? input.split(' ').first : '';
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) =>
                                ticketafter(orderId: tickets[index].id),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Strip (Status)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: C.theamecolor.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tickets[index].busname.toUpperCase(),
                                    style: TextStyle(
                                      color: C.theamecolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: C.theamecolor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "Confirmed",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Route Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "FROM",
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              firstWord(tickets[index].start),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "TO",
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              firstWord(tickets[index].end),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Divider
                                  Divider(
                                    color: Colors.grey[100],
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 16),
                                  // Details Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Date
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "DATE",
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            tickets[index].date,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Time
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "TIME",
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            tickets[index].time,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Seat
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "SEAT",
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            tickets[index].seat,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Booked On
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        tickets[index].timestamp != null
                                            ? "Booked on: ${DateFormat('d MMM, h:mm a').format(tickets[index].timestamp!)}"
                                            : "",
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
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
              },
            ),
    );
  }

  Future getdata() async {
    sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid') ?? '';
  }
}
