// ignore_for_file: prefer_const_constructors

import 'dart:convert';
// import 'dart:html';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';

import 'package:http/http.dart' as http;
import 'package:ticketbooking/utils/urlpage.dart';
import 'dart:ui';
// import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

// ignore: must_be_immutable
class busdetails extends StatefulWidget {
  Admin admin;
  busdetails(this.admin, {super.key});

  @override
  State<busdetails> createState() => _busdetailsState(admin);
}

class _busdetailsState extends State<busdetails> {
  File? pickedbusImage;
  TextEditingController busnamecontroller = TextEditingController();
  TextEditingController busregnocontroller = TextEditingController();
  TextEditingController bustypecontroller = TextEditingController();
  TextEditingController busseatnocontroller = TextEditingController();
  TextEditingController busupdepotcontroller = TextEditingController();
  TextEditingController ticketpricecontroller = TextEditingController();
  String status = '';
  GlobalKey<FormState> formkey = GlobalKey();

  Admin admin;
  _busdetailsState(this.admin);
  late SharedPreferences sp;

  bool phonetype = false;
  @override
  void initState() {
    super.initState();

    busnamecontroller.text = admin.busname;
    busregnocontroller.text = admin.regno;
    busseatnocontroller.text = admin.seatno;
    bustypecontroller.text = admin.type;
    busupdepotcontroller.text = admin.updepot;
    ticketpricecontroller.text = admin.ticketprice;
    statuscheck();
  }

  void statuscheck() {
    String st = admin.status;
    if (st == '0') {
      status = 'OFF';
      type = false;
    } else {
      status = 'ON';
      type = true;
    }
  }

  bool type = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          backgroundColor: C.theamecolor,
          title: Text(
            "Bus details",
            style: TextStyle(color: C.textfromcolor),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              child: type
                  ? Icon(
                      Icons.toggle_on_rounded,
                      color: Colors.white,
                      size: 50,
                    )
                  : Icon(
                      Icons.toggle_off_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
              onPressed: () {
                statuschange(admin.regno).whenComplete(() {
                  setState(
                    () {
                      type = !type;
                      statuscheck();
                    },
                  );
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 255, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 233, 230, 230),
                      ),
                      // height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 8, left: 10),
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            // height: 650,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 105, 105, 105)
                                      .withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  // ignore: prefer_const_constructors.
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 265,
                                  child: const Text(
                                    "Bus Name",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 220,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.busname,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {});
                                        showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Enter Bus Name',
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                              actions: [
                                                Form(
                                                  key: formkey,
                                                  child: Container(
                                                      height: 30,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 30),
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Cannot left Blank!';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        controller:
                                                            busnamecontroller,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if (formkey.currentState!
                                                        .validate()) {
                                                      busnameupdate(
                                                          admin.regno,
                                                          busnamecontroller
                                                              .text);
                                                    }

                                                    //
                                                  },
                                                  child: const Text(
                                                    'OK',
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: Color.fromARGB(255, 16, 7, 45),
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 265,
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: const Text(
                                    "Reg.No.",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 16, 7, 45)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 265,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.regno,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 185,
                                      child: const Text(
                                        "Bus Type",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 80,
                                      child: const Text(
                                        "Seat no.",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 185,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.type,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.seatno,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 185,
                                      child: const Text(
                                        "Up Depot",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 80,
                                      child: const Text(
                                        "Time",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 185,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.updepot,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.uptime,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 185,
                                      child: const Text(
                                        "Down Depot",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 80,
                                      child: const Text(
                                        "Time",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 185,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.downdepot,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        admin.downtime,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 185,
                                      child: const Text(
                                        "Traveling Time",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: 80,
                                      child: const Text(
                                        "Status",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 185,
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        admin.uptvtime,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 0),
                                      width: 265,
                                      child: const Text(
                                        "Ticket Price",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 16, 7, 45)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 185,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "₹ ${admin.ticketprice}",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 16, 7, 45),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {});
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Enter Amount here!',
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                ),
                                                actions: [
                                                  Form(
                                                    key: formkey,
                                                    child: Container(
                                                        height: 30,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30),
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Cannot left Blank!';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          controller:
                                                              ticketpricecontroller,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      if (formkey.currentState!
                                                          .validate()) {
                                                        Ticketpriceupdate(
                                                            admin.regno,
                                                            ticketpricecontroller
                                                                .text);
                                                      }

                                                      //
                                                    },
                                                    child: const Text(
                                                      'Change',
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Color.fromARGB(255, 16, 7, 45),
                                          size: 25,
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
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: C.theamecolor, width: 5),
                          right: BorderSide(),
                        ),
                        color: C.theamecolor,
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        "asset/image/bus48.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 5,
                      child: pickedbusImage != null
                          ? CircleAvatar(
                              radius: 65,
                              backgroundColor: Color.fromARGB(255, 8, 4, 49),
                              child: CircleAvatar(
                                backgroundImage: FileImage(pickedbusImage!),
                                radius: 60,
                              ),
                            )
                          : CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor:
                                    const Color.fromARGB(255, 212, 182, 182),
                                backgroundImage: NetworkImage(
                                  MyUrl.fullurl +
                                      MyUrl.busimageurl +
                                      admin.busimage,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 210,
                      left: 95,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: C.theamecolor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Choose Profile Pic"),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          pickImage(ImageSource.camera)
                                              .whenComplete(() {
                                            if (pickedbusImage != null) {
                                              busPicUpload(
                                                  pickedbusImage!, admin.regno);
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          Icons.camera,
                                          size: 40,
                                        ),
                                        label: Text(
                                          "Camera",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          pickImage(ImageSource.gallery)
                                              .whenComplete(() {
                                            if (pickedbusImage != null) {
                                              busPicUpload(
                                                  pickedbusImage!, admin.regno);
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent),
                                        icon: Icon(
                                          Icons.photo_library_outlined,
                                          size: 40,
                                        ),
                                        label: Text(
                                          "Gallery",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        "Please try to upload a PNG file!*",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> statuschange(String regno) async {
    Map data = {
      "regno": regno,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http
          .post(Uri.parse("${MyUrl.fullurl}status_change.php"), body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == 'true') {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
        admin.status = jsondata['st'];
        setState(() {});
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future<void> busnameupdate(String regno, String busname) async {
    Map data = {
      "regno": regno,
      "busname": busname,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http
          .post(Uri.parse("${MyUrl.fullurl}busname_update.php"), body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
        admin.busname = jsondata['newname'];
        setState(() {});
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future<void> Ticketpriceupdate(String regno, String price) async {
    Map data = {
      "regno": regno,
      "price": price,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http.post(
          Uri.parse("${MyUrl.fullurl}ticket_price_update.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
        admin.ticketprice = jsondata['newprice'];
        setState(() {});
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future pickImage(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedbusImage = tempImage;
      });

      // Get.back();e
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // busimage upload
  Future busPicUpload(File busphoto, String regno) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("${MyUrl.fullurl}bus_pic.php"));
      request.files.add(http.MultipartFile.fromBytes(
          'busimage', busphoto.readAsBytesSync(),
          filename: busphoto.path.split("/").last));
      request.fields['regno'] = regno;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        sp = await SharedPreferences.getInstance();

        admin.busimage = jsondata['imgtitle'];

        sp.setString("busimage", admin.busimage);

        setState(() {});

        Navigator.pop(context);

        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }
}
