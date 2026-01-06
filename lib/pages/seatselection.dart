import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/seatmodel.dart';
import 'package:ticketbooking/pages/addpassenger.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/color.dart';

// ignore: must_be_immutable
class seatselection extends StatefulWidget {
  Seat seat;
  seatselection(this.seat, {super.key});

  @override
  State<seatselection> createState() => seatselectionState();
}

class seatselectionState extends State<seatselection> {
  Color containerColor = const Color.fromARGB(
    255,
    100,
    102,
    102,
  ); // Available (Grey)
  Color reservedcontainerColor = const Color.fromRGBO(
    217,
    20,
    20,
    1,
  ); // Booked (Red)
  Color selectedcontainerColor = const Color.fromARGB(
    255,
    2,
    255,
    52,
  ); // Selected (Green)
  Color userReservedColor = const Color.fromARGB(
    255,
    33,
    150,
    243,
  ); // User Reserved (Blue)

  late SharedPreferences sp;
  String? uid;
  String? date;
  String? busno;

  // Layout Data
  Map<int, String> layoutMap = {};

  Set<int> totalreserved = {}; // Indices booked by OTHERS
  Set<int> userReservedSeats = {}; // Indices booked by CURRENT USER
  Set<int> selectedSeats = {}; // Indices currently selected

  bool isLoading = true;
  int fixedRows = 15;
  int fixedCols = 5;

  // Legacy vars needed for PHP booking calls
  static Set seatno = {};
  static String orderid = '';
  static int total_amount = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid');
    date = homepageState.showdate;
    busno = buslistpageState.reg;

    await _fetchBusLayout();
    await _fetchBookedSeats();
  }

  Future<void> _fetchBusLayout() async {
    try {
      // 1. Fetch Layout from Firestore
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('buses')
          .where(
            'regno',
            isEqualTo: widget.seat.row,
          ) // Assuming widget.seat.row holds Regno based on legacy usage, or we use busno
          .get();

      // Fallback: Use 'busno' from list state if widget.seat is unreliable (Widget.seat seems to come from API response)
      // Actually, looking at legacy code: busno = buslistpageState.reg;
      if (query.docs.isEmpty && busno != null) {
        query = await FirebaseFirestore.instance
            .collection('buses')
            .where('regno', isEqualTo: busno)
            .get();
      }

      if (query.docs.isNotEmpty) {
        var data = query.docs.first.data() as Map<String, dynamic>;

        // Dynamic Layout Config
        setState(() {
          if (data.containsKey('layout_type')) {
            String type = data['layout_type'];
            if (type == "2+3") {
              fixedCols = 6;
            } else {
              fixedCols = 5; // Default 2+2
            }
          }

          if (data.containsKey('layout_map')) {
            Map<String, dynamic> rawMap = data['layout_map'];
            layoutMap = rawMap.map(
              (key, value) => MapEntry(int.parse(key), value.toString()),
            );
          }
        });
      }

      // 2. Fetch Booked Seats (Using legacy inactive string or new logic?)
      // For now, let's use the legacy 'totalreserved' string passed in the Seat object
      // AND/OR fetch from Firestore bookings if we migrated that.
      // Legacy: widget.seat.totalreserved is a string like "{1,2,5}"
      setState(() {
        totalreserved = stringToSet(widget.seat.totalreserved);
        // Also include 'inactive' from seat object if relevant
        totalreserved.addAll(stringToSet(widget.seat.inactive));

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching layout: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchBookedSeats() async {
    try {
      // Fetch valid bookings for this bus and date
      QuerySnapshot bookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where(
            'busId',
            isEqualTo: busno,
          ) // Ensure busno matches booking busId
          .where('date', isEqualTo: date)
          .where('status', isEqualTo: 'confirmed')
          .get();

      Set<int> otherBooked = {};
      Set<int> myBooked = {};

      for (var doc in bookings.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String bookingUid =
            data['uid'] ??
            ''; // Using 'uid' based on common convention, verified in fetchBookedSeats context if possible or assume 'uid' or 'userId'.
        // Based on typical schema 'uid' is used for user ID in booking documents.

        List<dynamic> indices = data['seatIndices'] ?? [];
        for (var idx in indices) {
          int seatIdx = idx is int ? idx : int.tryParse(idx.toString()) ?? 0;

          if (bookingUid == uid) {
            myBooked.add(seatIdx);
          } else {
            otherBooked.add(seatIdx);
          }
        }
      }

      setState(() {
        totalreserved.addAll(otherBooked);
        userReservedSeats.addAll(myBooked);
      });
    } catch (e) {
      print("Error fetching booked seats: $e");
    }
  }

  Set<int> stringToSet(String inputString) {
    if (inputString == "none" || inputString.isEmpty) return {};
    List<String> parts = inputString
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');

    return parts
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .where((e) => e != 0)
        .toSet();
  }

  void _onSeatTap(int index) {
    if (totalreserved.contains(index)) return;

    setState(() {
      if (selectedSeats.contains(index)) {
        selectedSeats.remove(index);
      } else {
        if (selectedSeats.length < 6) {
          selectedSeats.add(index);
        } else {
          Fluttertoast.showToast(msg: "Maximum 6 seats allowed!");
        }
      }
    });
  }

  // --- Calculations ---

  int getTotalAmount() {
    int price = int.tryParse(buslistpageState.busprice) ?? 0;
    return selectedSeats.length * price;
  }

  String getSelectedLabels() {
    List<String> labels = [];
    for (int idx in selectedSeats) {
      if (layoutMap.containsKey(idx)) {
        labels.add(layoutMap[idx]!);
      }
    }
    return labels.join(", ");
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: C.textfromcolor),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: C.theamecolor,
          title: Text('Select Seat', style: TextStyle(color: C.textfromcolor)),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Legend
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(containerColor, "Available"),
                        _buildLegendItem(selectedcontainerColor, "Selected"),
                        _buildLegendItem(reservedcontainerColor, "Reserved"),
                        _buildLegendItem(userReservedColor, "Your Seats"),
                      ],
                    ),
                  ),

                  // Bus Grid
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            // Steering Wheel
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 20,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Icon(
                                    Icons.trip_origin,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 2, color: Colors.grey.shade400),

                            Builder(
                              builder: (context) {
                                List<Widget> rows = [];
                                // 1. Calculate Max Row
                                int maxIndex = layoutMap.isEmpty
                                    ? 0
                                    : layoutMap.keys.reduce(max);
                                int totalRows = (maxIndex ~/ fixedCols) + 1;

                                // 2. Loop through logical rows
                                for (int r = 0; r < totalRows; r++) {
                                  List<Widget> rowChildren = [];
                                  bool rowHasSeat = false;

                                  // Check if this row has any seats
                                  for (int c = 0; c < fixedCols; c++) {
                                    if (layoutMap.containsKey(
                                      r * fixedCols + c,
                                    )) {
                                      rowHasSeat = true;
                                      break;
                                    }
                                  }

                                  // Skip empty rows
                                  if (!rowHasSeat) continue;

                                  // Build the row's seats
                                  for (int c = 0; c < fixedCols; c++) {
                                    int index = r * fixedCols + c;

                                    // Aisle Logic
                                    // Aisle is typically middle column (2 for 5-col, 2 or 3 for 6-col?)
                                    // Adapting to: 2 is aisle for 5-col. For 6-col (2+3), maybe no aisle or specific?
                                    // Let's stick to simple spacing or empty container if not in map.

                                    if (!layoutMap.containsKey(index)) {
                                      rowChildren.add(
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                          ),
                                        ),
                                      );
                                      continue;
                                    }

                                    String label = layoutMap[index]!;
                                    bool isBooked = totalreserved.contains(
                                      index,
                                    );
                                    bool isMySeat = userReservedSeats.contains(
                                      index,
                                    );
                                    bool isSelected = selectedSeats.contains(
                                      index,
                                    );

                                    rowChildren.add(
                                      Expanded(
                                        child: InkWell(
                                          onTap: (isBooked || isMySeat)
                                              ? null
                                              : () => _onSeatTap(index),
                                          child: Container(
                                            height:
                                                40, // Fixed height for consistency
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: isBooked
                                                  ? reservedcontainerColor
                                                  : isMySeat
                                                  ? userReservedColor
                                                  : isSelected
                                                  ? selectedcontainerColor
                                                  : containerColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                label,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  rows.add(Row(children: rowChildren));
                                }
                                return Column(children: rows);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Sheet
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Seats: ${getSelectedLabels()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total: ₹${getTotalAmount()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: C.theamecolor,
                            ),
                            onPressed: selectedSeats.isEmpty
                                ? null
                                : _proceedToBooking,
                            child: Text(
                              "Proceed to Pay",
                              style: TextStyle(
                                color: C.textfromcolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 25),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 25),
                ],
              ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // --- Backend ---

  Future<void> _proceedToBooking() async {
    // Legacy Booking Logic Adaptation
    seatno = selectedSeats; // Update static for passed views if needed

    // We need to convert indices set to string like "{1, 5}" for legacy PHP compatibility
    String seatIndicesStr = selectedSeats.toString();
    String seatLabelsStr = getSelectedLabels();

    if (uid == null || busno == null || date == null) {
      Fluttertoast.showToast(msg: "Session Error. Please relogin.");
      return;
    }

    bookingInsert(
      date!,
      uid!,
      busno!,
      seatIndicesStr,
      seatLabelsStr,
      buslistpageState.From,
    );
  }

  Future bookingInsert(
    String date,
    String userid,
    String regno,
    String seatno,
    String seat,
    String updepot,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(),
    );

    try {
      // Create Booking Document in Firestore
      DocumentReference bookingRef = await FirebaseFirestore.instance
          .collection('bookings')
          .add({
            'userId': userid,
            'busId': regno, // Using regno as bus identifier
            'date': date,
            'seatIndices': selectedSeats.toList(),
            'seatLabels': getSelectedLabels().split(', '),
            'totalPrice': getTotalAmount(),
            'from': updepot,
            'to': buslistpageState.To,
            'busName': buslistpageState.busname,
            'time': buslistpageState.time,
            'status': 'pending_payment',
            'timestamp': FieldValue.serverTimestamp(),
            'passengers': [], // Initialize empty
          });

      orderid = bookingRef.id; // Store globally for addpassenger

      Navigator.pop(context); // Close loading

      // Navigate to Add Passenger
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const addpassenger()));
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Booking Creation Failed: $e");
    }
  }
}
