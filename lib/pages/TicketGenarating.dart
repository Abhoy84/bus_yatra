import 'dart:convert';
// import 'dart:html';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/firstticket.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/loadingdialog.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/seatselection.dart';
import 'package:ticketbooking/utils/urlpage.dart';

class ticketcreator extends StatefulWidget {
  const ticketcreator({super.key});

  @override
  State<ticketcreator> createState() => _ticketcreatorState();
}

class _ticketcreatorState extends State<ticketcreator> {
  @override
  void initState() {
    setvalue().whenComplete(() {
      showBeautifulLoadingDialog(context).whenComplete(() => setState(() {
            ticketdetailsInsert(
                buslistpageState.time,
                seatselectionState.orderid,
                buslistpageState.From,
                buslistpageState.To,
                seatselectionState.total_amount.toString(),
                buslistpageState.busname,
                username,
                buslistpageState.reg);
          }));
    });
    // TODO: implement initState
    super.initState();
  }

  late SharedPreferences sp;
  String? date;
  String? uid;
  String? regno;
  String? seatno;
  String username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.theamecolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (builder) => const buslistpage()));
          },
        ),
        title: const Text("Ticket creation"),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            // ticketdetailsInsert(
            //     buslistpageState.time,
            //     seatselectionState.orderid,
            //     buslistpageState.From,
            //     buslistpageState.To,
            //     seatselectionState.total_amount.toString(),
            //     buslistpageState.busname);

            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (builder) => ticket()));
            // booking(date!, uid!, regno!, seatno!);
          },
          child: Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 4, 18, 63),
                  Color.fromARGB(255, 12, 50, 150),
                  Color.fromARGB(255, 19, 93, 239)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Ganerateing Ticket... '.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // cvdd

  Future ticketdetailsInsert(
      String time,
      String orderid,
      String from,
      String to,
      String amount,
      String busname,
      String username,
      String busid) async {
    Map data = {
      'orderid': orderid,
      'from': from,
      'to': to,
      'time': time,
      'amount': amount,
      'busname': busname,
      'username': username,
      'busid': busid
    };

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var respond = await http
          .post(Uri.parse("${MyUrl.fullurl}ticket_insert.php"), body: data);
      var jsondata = jsonDecode(respond.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (builder) => const ticketafter()));
        Fluttertoast.showToast(msg: jsondata['msg']);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata['msg']);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // DateTime stringtodate(String dateString) {
  //   try {
  //     final dateFormat = DateFormat('yyyy/MM/dd');
  //     return dateFormat.parseStrict(dateString);
  //   } catch (e) {
  //     // Handle parsing error
  //     print('Error parsing date: $e');
  //     return DateTime.now(); // or return a default DateTime if needed
  //   }
  // }

  Future<void> setvalue() async {
    sp = await SharedPreferences.getInstance();
    date = homepageState.showdate!;
    uid = sp.getString('uid');
    regno = buslistpageState.reg;
    seatno = seatselectionState.seatno.toString();
    username = sp.getString("fname")!;
  }
}





// void main() {
//   final str = "22/10/2003";
//   final date = parseDateString(str);
//   if (date != null) {
//     print('Parsed Date: $date');
//   }
// }
