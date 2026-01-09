// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ticketbooking/pages/common/color.dart';
// import 'package:ticketbooking/pages/common/loadingdialog.dart';
// import 'package:ticketbooking/pages/common/loadingdialoge.dart';
// import 'package:ticketbooking/pages/user/buslist.dart';
// import 'package:ticketbooking/pages/user/firstticket.dart';
// import 'package:ticketbooking/pages/user/homepage.dart';
// import 'package:ticketbooking/pages/user/seatselection.dart';

// import 'package:ticketbooking/services/notification_service.dart';

// class ticketcreator extends StatefulWidget {
//   const ticketcreator({super.key});

//   @override
//   State<ticketcreator> createState() => _ticketcreatorState();
// }

// class _ticketcreatorState extends State<ticketcreator> {
//   @override
//   void initState() {
//     setvalue().whenComplete(() {
//       showBeautifulLoadingDialog(context).whenComplete(
//         () => setState(() {
//           ticketdetailsInsert(seatselectionState.orderid);
//         }),
//       );
//     });
//     // TODO: implement initState
//     super.initState();
//   }

//   late SharedPreferences sp;
//   String? date;
//   String? uid;
//   String? regno;
//   String? seatno;
//   String username = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: C.theamecolor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (builder) => const buslistpage()),
//             );
//           },
//         ),
//         title: const Text("Ticket creation"),
//       ),
//       body: Center(
//         child: InkWell(
//           onTap: () {
//             // ticketdetailsInsert(
//             //     buslistpageState.time,
//             //     seatselectionState.orderid,
//             //     buslistpageState.From,
//             //     buslistpageState.To,
//             //     seatselectionState.total_amount.toString(),
//             //     buslistpageState.busname);

//             // Navigator.of(context).pushReplacement(
//             //     MaterialPageRoute(builder: (builder) => ticket()));
//             // booking(date!, uid!, regno!, seatno!);
//           },
//           child: Container(
//             width: 300,
//             height: 200,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 4, 18, 63),
//                   Color.fromARGB(255, 12, 50, 150),
//                   Color.fromARGB(255, 19, 93, 239),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 'Ganerateing Ticket... '.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   // cvdd

//   Future ticketdetailsInsert(String orderid) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return const LoadingDialog();
//       },
//     );
//     try {
//       // Confirm the booking
//       await FirebaseFirestore.instance
//           .collection('bookings')
//           .doc(orderid)
//           .update({'status': 'confirmed'});

//       // Trigger Notification
//       await NotificationService().showLocalNotification(
//         "Booking Confirmed!",
//         "Your ticket has been successfully booked. Have a safe journey!",
//       );

//       Navigator.pop(context); // Close loading

//       // Navigate to Ticket View
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (builder) =>
//               ticketafter(orderId: orderid, isFromBooking: true),
//         ),
//       );

//       Fluttertoast.showToast(msg: "Ticket Generated Successfully!");
//     } catch (e) {
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: "Failed to generate ticket: $e");
//     }
//   }

//   // DateTime stringtodate(String dateString) {
//   //   try {
//   //     final dateFormat = DateFormat('yyyy/MM/dd');
//   //     return dateFormat.parseStrict(dateString);
//   //   } catch (e) {
//   //     // Handle parsing error
//   //     print('Error parsing date: $e');
//   //     return DateTime.now(); // or return a default DateTime if needed
//   //   }
//   // }

//   Future<void> setvalue() async {
//     sp = await SharedPreferences.getInstance();
//     date = homepageState.showdate!;
//     uid = sp.getString('uid');
//     regno = buslistpageState.reg;
//     seatno = seatselectionState.seatno.toString();
//     username = sp.getString("fname")!;
//   }
// }

// // void main() {
// //   final str = "22/10/2003";
// //   final date = parseDateString(str);
// //   if (date != null) {
// //     print('Parsed Date: $date');
// //   }
// // }
