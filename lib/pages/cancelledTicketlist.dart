import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:ticketbooking/pages/firstticket.dart';

class cancelledticketlist extends StatefulWidget {
  const cancelledticketlist({super.key});

  @override
  State<cancelledticketlist> createState() => cancelledticketlistState();
}

class cancelledticketlistState extends State<cancelledticketlist> {
  late SharedPreferences sp;
  String uid = '';

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
            // Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: Icon(Icons.home, color: C.textfromcolor),
        ),
        backgroundColor: C.theamecolor,
        title: Text(
          "Cancelled Tickets",
          style: TextStyle(color: C.textfromcolor),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: uid)
            .where('status', isEqualTo: 'cancelled')
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
                child: Column(
                  children: [
                    const Icon(Icons.block, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      "No Cancelled Tickets Found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          tickets.clear();
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            String seatStr = "";
            if (data['seatLabels'] is List) {
              seatStr = (data['seatLabels'] as List).join(',');
            } else {
              seatStr = data['seatLabels'].toString();
            }

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
              status: data['status'] ?? 'cancelled',
              username: '',
              busid: data['busId'] ?? '',
              userid: data['userId'] ?? '',
              timestamp: data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : null,
            );
            tickets.add(ticket);
          }

          // Client-side sorting
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
                          color: Colors.red.withOpacity(
                            0.1,
                          ), // Red for cancelled
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tickets[index].busname.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.red, // Red Text
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
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "Cancelled",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                            Divider(color: Colors.grey[100], thickness: 1),
                            const SizedBox(height: 16),
                            // Details Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Date
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                // Amount (Refund info maybe?)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "AMOUNT",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "₹${tickets[index].amount}",
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
                                      ? "Cancelled"
                                      : "",
                                  style: TextStyle(
                                    color: Colors.red[300],
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
