import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:ticketbooking/pages/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketbooking/pages/passengerlistafter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketbooking/pages/seatselection.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketbooking/models/usermodel.dart' as model;
import 'package:ticketbooking/pages/homepage.dart';

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
  bool showQr = false;
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
          // If from booking, we want to reset to home to avoid back-stack confusion
          // However, blocking back button might be annoying.
          // Let's call our safe navigation.
          _navigateToHome();
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
                _navigateToHome();
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
                          _navigateToHome();
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
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _printPdf,
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          "Download Ticket",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
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
                const SizedBox(height: 20),
                const Divider(),
                // Verify / QR Section
                Center(
                  child: Column(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showQr = !showQr;
                          });
                        },
                        icon: Icon(
                          showQr
                              ? Icons.keyboard_arrow_up
                              : Icons.qr_code_scanner,
                          color: C.theamecolor,
                        ),
                        label: Text(
                          showQr ? "Hide QR Code" : "Verify Ticket",
                          style: TextStyle(
                            color: C.theamecolor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: showQr ? 200 : 0,
                        curve: Curves.easeInOut,
                        child: SingleChildScrollView(
                          child: showQr && id.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: QrImageView(
                                    data: id,
                                    version: QrVersions.auto,
                                    size: 180.0,
                                    foregroundColor: C.theamecolor,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.orange[800],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Please reach at least 15 mins before departure.",
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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

  Future<void> _navigateToHome() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          model.User user = model.User(
            fname: data['name'] ?? '', // Assuming 'name' field based on context
            email: currentUser.email ?? '',
            uid: currentUser.uid,
            phone: data['phone'] ?? '',
            image: data['image'] ?? '',
          );

          Navigator.of(context).pop(); // Dismiss loading

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => homepage(user)),
            (route) => false,
          );
        } else {
          Navigator.of(context).pop(); // Dismiss loading
          Fluttertoast.showToast(msg: "User not found");
          // Fallback
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss loading
      Fluttertoast.showToast(msg: "Navigation Error: $e");
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _printPdf() async {
    final doc = pw.Document();
    // ... existing _printPdf content ...

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 350,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    "BUS YATRA TICKET",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "Ticket ID:",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        id,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    busname.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "FROM",
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            getFirstWord(start).toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "TO",
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            getFirstWord(end).toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "DATE",
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            date,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "TIME",
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            time,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "SEATS",
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            seat,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "PRICE",
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            "Rs. $amount",
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: id,
                    width: 100,
                    height: 100,
                  ),
                  pw.SizedBox(height: 10),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Show this QR code to conductor",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "IMPORTANT INSTRUCTIONS:",
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "• Please reach at least 15 minutes before departure at the pickup point.",
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                        pw.Text(
                          "• Carry a valid government issued ID proof.",
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name:
          "BusYatra_${getFirstWord(start)}_${getFirstWord(end)}_${DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now())}",
    );
  }
}
