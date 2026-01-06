import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:ticketbooking/pages/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/passengerlistafter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbooking/pages/seatselection.dart';

class ticketafter extends StatefulWidget {
  final String orderId;
  final bool isFromBooking;
  const ticketafter({
    super.key,
    required this.orderId,
    this.isFromBooking = false,
  });

  @override
  State<ticketafter> createState() => ticketafterState();
}

class ticketafterState extends State<ticketafter> {
  // ... existing variables ...
  double space = 40.0;
  String busname = '';
  String start = '';
  String end = '';
  String time = '';
  String date = '';
  String amount = '';
  static String id = '';
  String seat = '';
  String status = '';
  @override
  void initState() {
    getTicketDetails(widget.orderId).whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  String getFirstWord(String input) {
    if (input.isEmpty) return "";
    List<String> words = input.trim().split(' ');
    return words.isNotEmpty ? words[0] : input;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromBooking) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: C.textfromcolor),
            onPressed: () {
              if (widget.isFromBooking) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: C.theamecolor,
          title: Text(
            "Booking Confirmed",
            style: TextStyle(color: C.textfromcolor),
          ),
          centerTitle: true,
        ),
        body: id == ''
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildTicketCard(),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: C.theamecolor,
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Back to Home",
                          style: TextStyle(
                            color: C.textfromcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: C.theamecolor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TICKET",
                  style: TextStyle(
                    color: C.textfromcolor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  "ID: $id",
                  style: TextStyle(
                    color: C.textfromcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bus Name
                Center(
                  child: Text(
                    busname.toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: C.theamecolor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Route (From -> To)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FROM",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          getFirstWord(start).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.directions_bus, color: C.theamecolor, size: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "TO",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          getFirstWord(end).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                // Details Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem("DATE", date),
                    _buildDetailItem("TIME", time),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem("SEATS", seat),
                    _buildDetailItem("PRICE", "₹$amount"),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Confirmed",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => const passengerlistafter(),
                          ),
                        );
                      },
                      child: Text(
                        "Passenger List >",
                        style: TextStyle(
                          color: C.theamecolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> getTicketDetails(String orderid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(orderid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Update UI Variables
        busname = data['busName'] ?? '';
        start = data['from'] ?? '';
        end = data['to'] ?? '';
        time = data['time'] ?? '';
        date = data['date'] ?? '';
        amount = data['totalPrice'].toString();
        id = doc.id;

        List seats = data['seatLabels'] ?? [];
        seat = seats.join(', ');

        status = data['status'] ?? '';

        Fluttertoast.showToast(msg: "Ticket Loaded Successfully");
      } else {
        Fluttertoast.showToast(msg: "Ticket Not Found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading ticket: $e");
    }
  }
}
