import 'package:flutter/src/widgets/framework.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/Ticketmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';

import 'package:ticketbooking/pages/common/loadingdialoge.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ticketbooking/pages/user/firstticket.dart';
import 'package:ticketbooking/pages/common/color.dart';

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
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;
  @override
  void initState() {
    getdata().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  List<Ticket> tickets = [];

  String firstWord(String input) {
    return input.isNotEmpty ? input.split(' ').first : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pop(context);
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
                          selectedDate = pickdate;
                          viewdate =
                              "  ${DateFormat('yMMMd').format(pickdate)}";
                          // Match the format used in ticket data: 'd MMM yyyy'
                          showdate = DateFormat('d MMM yyyy').format(pickdate);
                        } else {
                          selectedDate = currentdate;
                          viewdate =
                              "  ${DateFormat('yMMMEd').format(currentdate)}";
                          showdate = DateFormat(
                            'd MMM yyyy',
                          ).format(currentdate);
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

                    const SizedBox(height: 20),
                    // Text Search Field
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search by Bus Name, From, To...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: (MediaQuery.of(context).size.width - 120) / 2,
                          padding: const EdgeInsets.only(right: 5),
                          child: ElevatedButton(
                            child: const Text(
                              'SEARCH',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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
                        const SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: (MediaQuery.of(context).size.width - 120) / 2,
                          padding: const EdgeInsets.only(left: 5),
                          child: ElevatedButton(
                            child: const Text(
                              'CLEAR',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey, // Grey for clear
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              search = false;
                              searchController.clear();
                              selectedDate = null;
                              viewdate = null;
                              showdate = null;
                              setState(() {
                                allticket = true;
                              });
                            },
                          ),
                        ),
                      ],
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

                  String rawDate = data['date'] ?? '';
                  String formattedDate = rawDate;
                  try {
                    String cleanDate = rawDate.trim();
                    DateTime parsedDate;
                    try {
                      parsedDate = DateFormat('d MMM yyyy').parse(cleanDate);
                    } catch (_) {
                      try {
                        parsedDate = DateFormat(
                          'M/d/yyyy',
                        ).parseLoose(cleanDate);
                      } catch (__) {
                        try {
                          parsedDate = DateFormat(
                            'd/M/yyyy',
                          ).parseLoose(cleanDate);
                        } catch (___) {
                          try {
                            parsedDate = DateFormat(
                              'yyyy-MM-dd',
                            ).parse(cleanDate);
                          } catch (____) {
                            parsedDate = DateFormat(
                              'yyyy/MM/dd',
                            ).parse(cleanDate);
                          }
                        }
                      }
                    }
                    formattedDate = DateFormat('d MMM yyyy').format(parsedDate);
                  } catch (e) {
                    formattedDate = rawDate;
                  }

                  Ticket ticket = Ticket(
                    busname: data['busName'] ?? '',
                    start: data['from'] ?? '',
                    end: data['to'] ?? '',
                    id: doc.id,
                    seat: seatStr,
                    date: formattedDate,
                    time: data['time'] ?? '',
                    amount: amountStr,
                    status: data['status'] ?? 'confirmed',
                    username: '', // Not strictly needed for list view usually
                    busid: data['busId'] ?? '',
                    userid: data['userId'] ?? '',
                    timestamp: data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate()
                        : null,
                  );

                  // --- Auto-Complete Logic ---
                  if (ticket.status == 'confirmed') {
                    try {
                      String tTime = data['travelTime'] ?? '';
                      // Logic runs even if tTime is empty (for legacy support)
                      if (formattedDate.isNotEmpty && ticket.time.isNotEmpty) {
                        // Parse Date
                        DateTime dDate = DateFormat(
                          'd MMM yyyy',
                        ).parse(formattedDate);
                        DateTime now = DateTime.now();
                        DateTime today = DateTime(now.year, now.month, now.day);

                        // Check 1: Is the trip date strictly in the past (yesterday or older)?
                        if (dDate.isBefore(today)) {
                          FirebaseFirestore.instance
                              .collection('bookings')
                              .doc(ticket.id)
                              .update({'status': 'completed'});
                          ticket.status = 'completed';
                        } else if (dDate.isAtSameMomentAs(today)) {
                          // Check 2: Trip is today.
                          // Parse Departure Time
                          DateTime tTimeDt;
                          try {
                            tTimeDt = DateFormat.jm().parse(ticket.time);
                          } catch (_) {
                            tTimeDt = DateFormat("HH:mm").parse(ticket.time);
                          }
                          DateTime departure = DateTime(
                            dDate.year,
                            dDate.month,
                            dDate.day,
                            tTimeDt.hour,
                            tTimeDt.minute,
                          );

                          Duration duration;
                          if (tTime.isNotEmpty) {
                            // Bus has Travel Time
                            RegExp exp = RegExp(r'(\d+)');
                            Iterable<Match> matches = exp.allMatches(tTime);
                            int addHours = 0;
                            int addMins = 0;
                            if (matches.isNotEmpty) {
                              addHours = int.parse(
                                matches.elementAt(0).group(0)!,
                              );
                              if (matches.length > 1) {
                                addMins = int.parse(
                                  matches.elementAt(1).group(0)!,
                                );
                              }
                            }
                            duration = Duration(
                              hours: addHours,
                              minutes: addMins,
                            );
                          } else {
                            // Legacy Ticket Loophole: Default to 6 hours if unknown
                            duration = const Duration(hours: 6);
                          }

                          DateTime arrival = departure.add(duration);

                          if (now.isAfter(arrival)) {
                            // Mark Completed
                            FirebaseFirestore.instance
                                .collection('bookings')
                                .doc(ticket.id)
                                .update({'status': 'completed'});
                            ticket.status = 'completed';
                          }
                        }
                      }
                    } catch (e) {
                      print("Error in auto-complete logic: $e");
                    }
                  }
                  // ---------------------------
                  // ---------------------------

                  tickets.add(ticket);
                }

                // Client-side sorting to avoid Firestore Index requirement
                tickets.sort((a, b) {
                  if (a.timestamp == null && b.timestamp == null) return 0;
                  if (a.timestamp == null) return 1;
                  if (b.timestamp == null) return -1;
                  return b.timestamp!.compareTo(a.timestamp!);
                });

                // --- Filtering Logic ---
                if (!allticket) {
                  tickets = tickets.where((ticket) {
                    bool matchesDate = true;
                    bool matchesText = true;

                    // Filter by Date
                    if (showdate != null && showdate!.isNotEmpty) {
                      matchesDate = ticket.date == showdate;
                    }

                    // Filter by Text
                    if (searchController.text.isNotEmpty) {
                      String query = searchController.text.toLowerCase();
                      matchesText =
                          ticket.busname.toLowerCase().contains(query) ||
                          firstWord(
                            ticket.start,
                          ).toLowerCase().contains(query) ||
                          firstWord(ticket.end).toLowerCase().contains(query);
                    }

                    return matchesDate && matchesText;
                  }).toList();
                }
                // -----------------------

                return ListView.builder(
                  itemCount: tickets.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemBuilder: (BuildContext context, int index) {
                    // Helper to get first word
                    // String firstWord(String input) {
                    //   return input.isNotEmpty ? input.split(' ').first : '';
                    // }

                    bool isCancelled = tickets[index].status == 'cancelled';

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
                                color: isCancelled
                                    ? Colors.red.withOpacity(0.1)
                                    : C.theamecolor.withOpacity(0.1),
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
                                      color: isCancelled
                                          ? Colors.red
                                          : C.theamecolor,
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
                                      color: isCancelled
                                          ? Colors.red
                                          : C.theamecolor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isCancelled ? "Cancelled" : "Confirmed",
                                      style: const TextStyle(
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
                                  // Cancel Button
                                  if (!isCancelled) ...[
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _handleCancellation(tickets[index]);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel Booking & Refund",
                                        ),
                                      ),
                                    ),
                                  ],
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

  void _handleCancellation(Ticket ticket) {
    try {
      // 1. Parsing Logic
      // Trying to parse standard formats.
      // Date likely in 'M/d/yyyy' or 'yyyy-MM-dd' from DatePicker/Firestore
      // Time likely in 'h:mm a' (e.g., 5:30 PM) or 'HH:mm'

      // We'll try to find a best fit.
      // Based on showdate = DateFormat('yMd').format(pickdate) -> e.g. 1/8/2026

      DateFormat dateFormat = DateFormat('M/d/yyyy');
      // If your app uses a differnt locale or format, this might need adjustment.
      // Falling back to a flexible parser could be safer but 'yMd' is standard.

      // However, Firestore date string might differ. Let's try parsing.
      DateTime datePart;
      try {
        // Try the display format first, as that is what `ticket.date` likely contains
        datePart = DateFormat('d MMM yyyy').parse(ticket.date);
      } catch (e0) {
        try {
          datePart = dateFormat.parse(ticket.date);
        } catch (e) {
          // Fallback or try another format
          try {
            datePart = DateFormat('yyyy-MM-dd').parse(ticket.date);
          } catch (e2) {
            try {
              datePart = DateFormat('d/M/yyyy').parse(ticket.date);
            } catch (e3) {
              // Last resort: try loose parsing
              datePart = DateFormat.yMd().parseLoose(ticket.date);
            }
          }
        }
      }

      // Time Parsing
      // Assuming '5:30 PM' format
      DateFormat timeFormat = DateFormat.jm(); // 5:30 PM
      DateTime timePart;
      try {
        timePart = timeFormat.parse(ticket.time);
      } catch (e) {
        // Fallback to HH:mm
        timePart = DateFormat('HH:mm').parse(ticket.time);
      }

      // Combine parts
      DateTime departureTime = DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        timePart.hour,
        timePart.minute,
      );

      // 2. Business Logic: Check 2 hours
      DateTime now = DateTime.now();
      Duration diff = departureTime.difference(now);

      if (diff.isNegative) {
        Fluttertoast.showToast(
          msg: "This journey has already occurred. Cannot cancel past tickets.",
        );
        return;
      }

      if (diff.inHours < 2) {
        Fluttertoast.showToast(
          msg:
              "Cancellation is only allowed at least 2 hours before departure.",
        );
        return;
      }

      // 3. UI: Reason Dialog
      TextEditingController reasonController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Cancel Booking"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure you want to cancel? Refund will be processed to your original payment method.",
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: "Reason for cancellation",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (reasonController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please provide a reason");
                    return;
                  }
                  Navigator.pop(context); // Close dialog
                  _processCancellation(ticket.id, reasonController.text);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Confirm Cancel"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error verifying time: ${e.toString()}");
      // Fallback for demo or safety: allow cancel if parse fails? No, better safe.
    }
  }

  Future<void> _processCancellation(String ticketId, String reason) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(ticketId)
          .update({
            'status': 'cancelled',
            'refundStatus': 'pending',
            'cancellationReason': reason,
            'cancelledAt': FieldValue.serverTimestamp(),
          });

      Navigator.pop(context); // Close Loading
      Fluttertoast.showToast(msg: "Ticket cancelled. Refund request sent.");
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Failed to cancel: ${e.toString()}");
    }
  }
}
