import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/src/material/list_tile.dart';
import 'package:ticketbooking/models/depotmodel.dart';
import 'package:ticketbooking/pages/adminlogin.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AdminSign extends StatefulWidget {
  const AdminSign({super.key});

  @override
  State<AdminSign> createState() => _AdminSignState();
}

class _AdminSignState extends State<AdminSign> {
  String bustyperadiobutton = 'A/C';
  String uptimestatedropdownvalue = "am";
  String downtimestatedropdownvalue = "am";

  List<String> Depotlist = [];
  List<String> filteredDepotlist = [];
  List<String> Depotidlist = [];

  var uptimestate = ['am', 'pm'];
  var downtimestate = ['am', 'pm'];
  List<String> items = [];
  List<String> filteredItems = [];
  bool updepotshowList = false;
  bool downdepotshowList = false;

  bool isvisible = false;
  bool type = true;
  bool type1 = true;
  TextEditingController adminnamecontroller = TextEditingController();
  TextEditingController adminphonecontroller = TextEditingController();
  TextEditingController adminemailcontroller = TextEditingController();
  TextEditingController adminpasswordcontroller = TextEditingController();
  TextEditingController adminconfirmpasswordcontroller =
      TextEditingController();
  TextEditingController busnamecontroller = TextEditingController();
  TextEditingController busnocontroller = TextEditingController();
  TextEditingController busseatcapacitycontroller = TextEditingController();
  TextEditingController bustypecontroller = TextEditingController();
  TextEditingController busuptimecontroller = TextEditingController();
  TextEditingController bustravleminuptimecontroller = TextEditingController();
  TextEditingController bustravlehruptimecontroller = TextEditingController();
  TextEditingController busdowntimecontroller = TextEditingController();
  TextEditingController bustravlehrdowntimecontroller = TextEditingController();
  TextEditingController bustravlemindowntimecontroller =
      TextEditingController();
  TextEditingController updepotsearchController = TextEditingController();
  TextEditingController downdepotsearchController = TextEditingController();
  TextEditingController busticketpricecontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  String password = '';
  String ConfirmPassword = '';

  void _filterItems(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredDepotlist = Depotlist.where(
        (item) => item.toLowerCase().contains(query),
      ).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getdepot();
  }

  Future getdepot() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('depots')
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          Depotlist.clear();
          Depotidlist.clear();
          for (var doc in snapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String name = data['depot_name'] ?? '';
            // Assuming depot_id is the doc ID or a field. Using doc ID is safer if migrated that way.
            // If manual migration used specific IDs, we can use doc.id.
            String id = doc.id;

            Depotlist.add(name);
            Depotidlist.add(id);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> voidlog(
    String name,
    String phone,
    String email,
    String passcode,
    String busName,
    String regno,
    String seatno,
    String bustype,
    String updepot,
    String uptime,
    String uptvtime,
    String downdepot,
    String downtime,
    String downtvtime,
    String ticketprice,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      // 1. Create User in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passcode);

      String uid = userCredential.user!.uid;

      // 2. Prepare Data for Firestore
      // Using UID as Document ID to easily link Admin to their Bus
      Map<String, dynamic> busData = {
        "admin_id": uid,
        "name": name,
        "phone": phone,
        "email": email,
        // "passcode": passcode, // Don't store passwords in plain text!
        "busname": busName,
        "regno": regno,
        "seatno": seatno,
        "type": bustype,
        "updepot": updepot,
        "uptime": uptime,
        "uptvtime": uptvtime,
        "downdepot": downdepot,
        "downtime": downtime,
        "downtvtime": downtvtime,
        "ticketprice": ticketprice,
        "busimage": "default.png", // specific default or logic
        "busstatus": "active", // default status
        "created_at": FieldValue.serverTimestamp(),
      };

      // 3. Save to Firestore 'buses' collection
      await FirebaseFirestore.instance
          .collection('buses')
          .doc(uid)
          .set(busData);

      // 4. Success Navigation
      Navigator.pop(context); // Close dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Adminlogin()),
      );
      Fluttertoast.showToast(msg: "Account Created Successfully!");
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.message ?? "Auth Error");
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: C.theamecolor,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                child: Image.asset(
                                  "asset/image/busroad2.png",
                                  scale: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 69, top: 30),
                            child: Container(
                              height: 50,
                              width: 260,
                              margin: const EdgeInsets.only(),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    "Creat Account Here!",
                                    speed: const Duration(seconds: 1),
                                    textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 254, 254, 254),
                                      fontFamily: "lobster",
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    colors: [
                                      const Color.fromARGB(255, 255, 255, 255),
                                      Colors.yellow,
                                      const Color.fromARGB(255, 255, 255, 255),
                                    ],
                                  ),
                                ],
                                pause: const Duration(milliseconds: 100),
                                repeatForever: true,
                                isRepeatingAnimation: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          // left: 30,
                          top: 30,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 320,
                                  height: 70,
                                  child: TextFormField(
                                    controller: adminnamecontroller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Cannot left Blank!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintText: "FULL NAME",
                                      hintStyle: TextStyle(
                                        color: C.textfromcolor,
                                      ),
                                      labelText: "Full name ",
                                      labelStyle: TextStyle(
                                        color: C.fromfeildcolor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person_2_outlined,
                                        color: Colors.white,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: C.fromfeildcolor,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: C.fromfeildcolor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(color: C.textfromcolor),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 320,
                                  height: 70,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: adminphonecontroller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Cannot left Blank!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintText: "PHONE NUMBER",
                                      hintStyle: TextStyle(
                                        color: C.textfromcolor,
                                      ),
                                      labelText: "Phone number ",
                                      labelStyle: TextStyle(
                                        color: C.fromfeildcolor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.phone_android_outlined,
                                        color: Colors.white,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: C.fromfeildcolor,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: C.fromfeildcolor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(color: C.textfromcolor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: adminemailcontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Cannot left Blank!';
                                } else if (!RegExp(
                                  r'[^0-9]+[a-zA-Z0-9]+@+gmail+\.+com',
                                ).hasMatch(value)) {
                                  return 'Please enter Valide email id';
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "ENTER MAIL ID",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "e-mail id ",
                                labelStyle: TextStyle(color: C.fromfeildcolor),
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: adminpasswordcontroller,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return ' Passcode Requried!';
                                }
                                if (value.trim().length <= 3) {
                                  return "Contains atleast 4 number";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) => password = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              obscureText: type,
                              obscuringCharacter: '*',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "ENTER PASSCODE",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: " Create Passcode",
                                labelStyle: TextStyle(color: C.fromfeildcolor),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                suffixIcon: TextButton(
                                  child: type
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      type = !type;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: adminconfirmpasswordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }
                                if (value != password) {
                                  return 'Confimation passcode does not match';
                                }
                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              obscureText: type1,
                              obscuringCharacter: '*',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "CONFIRM PASSCODE",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Confirm passcode",
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.check_box_outlined,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                suffixIcon: TextButton(
                                  child: type1
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      type1 = !type1;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 50,
                            child: const Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 50,
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "Bus Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.034,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 50,
                            child: const Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: busnamecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Cannot left Blank!';
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "BUS NAME",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Bus name ",
                                labelStyle: TextStyle(color: C.fromfeildcolor),
                                prefixIcon: const Icon(
                                  Icons.directions_bus_outlined,
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: busnocontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Cannot left Blank!';
                                } else if (!RegExp(
                                  r'^[A-Z]{2}\s[0-9]{2}\s[A-Z]{2}\s[0-9]{4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter Valide email id';
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "ENTER BUS REG.NO.",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Bus Reg.No. ",
                                labelStyle: TextStyle(color: C.fromfeildcolor),
                                prefixIcon: const Icon(
                                  Icons.directions_bus_filled_outlined,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: C.fromfeildcolor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: busseatcapacitycontroller,
                              // controller: confirmPasswordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: " SEAT CAPACITY",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Seat Capacity",
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.chair_outlined,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 324,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 50,
                              child: Radio(
                                fillColor: WidgetStateColor.resolveWith((
                                  Set<WidgetState> states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.white;
                                }),
                                value: "A/C",
                                groupValue: bustyperadiobutton,
                                onChanged: (value) {
                                  setState(() {
                                    bustyperadiobutton = value.toString();
                                    bustypecontroller.text = bustyperadiobutton;
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 90,
                              child: Text(
                                "A/C",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.036,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 50,
                              color: C.theamecolor,
                              child: Radio(
                                fillColor: WidgetStateColor.resolveWith((
                                  Set<WidgetState> states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.white;
                                }),
                                value: "NON A/C",
                                groupValue: bustyperadiobutton,
                                onChanged: (value) {
                                  setState(() {
                                    bustyperadiobutton = value.toString();
                                    bustypecontroller.text = bustyperadiobutton;
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: 90,
                              color: C.theamecolor,
                              child: Text(
                                "NON A/C",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.036,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 320,
                                height: 70,
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      updepotshowList = true;
                                    });
                                  },
                                  controller: updepotsearchController,
                                  onChanged: _filterItems,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    hintText: "UP DEPOT",
                                    hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    labelText: "UP DEPOT",
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.directions_bus_filled_outlined,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              if (updepotshowList)
                                Container(
                                  width: 300.0,
                                  height: 200.0,
                                  color: const Color.fromARGB(16, 70, 200, 150),
                                  child: ListView.builder(
                                    itemCount: filteredDepotlist.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          Depotlist[index].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            updepotsearchController.text =
                                                filteredDepotlist[index];
                                            updepotshowList = false;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                              bottom: 10,
                            ),
                            width: 230,
                            height: 70,
                            child: TextFormField(
                              controller: busuptimecontroller,
                              // controller: confirmPasswordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: " UP TIME",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Up Time",
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.timelapse,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: 80,
                            height: 60,
                            padding: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              value: uptimestatedropdownvalue,
                              alignment: Alignment.centerRight,
                              dropdownColor: C.theamecolor,

                              // Down Arrow Icon
                              underline: Container(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 40,
                              ),

                              items: uptimestate.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(
                                      color: C.textfromcolor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  uptimestatedropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                              bottom: 20,
                            ),
                            width: 155,
                            height: 60,
                            child: TextFormField(
                              controller: bustravlehruptimecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: " Travel time in hour",
                                hintStyle: TextStyle(
                                  color: C.textfromcolor,
                                  fontSize: 15,
                                ),
                                labelText: "Travel time in hour",
                                labelStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 0, bottom: 20),
                            width: 155,
                            height: 60,
                            child: TextFormField(
                              controller: bustravleminuptimecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "Travel time in minute",
                                hintStyle: TextStyle(
                                  color: C.textfromcolor,
                                  fontSize: 13,
                                ),
                                labelText: "Travel time in minute",
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  downdepotshowList = true;
                                });
                              },
                              controller: downdepotsearchController,
                              onChanged: _filterItems,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "DOWN DEPOT",
                                hintStyle: const TextStyle(color: Colors.white),
                                labelText: "DOWN DEPOT",
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                prefixIcon: const Icon(
                                  Icons.directions_bus_filled_outlined,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          if (downdepotshowList)
                            Container(
                              width: 300.0,
                              height: 200.0,
                              color: const Color.fromARGB(16, 70, 200, 150),
                              child: ListView.builder(
                                itemCount: filteredDepotlist.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      Depotlist[index].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        downdepotsearchController.text =
                                            filteredDepotlist[index];
                                        downdepotshowList = false;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                              bottom: 10,
                            ),
                            width: 230,
                            height: 70,
                            child: TextFormField(
                              controller: busdowntimecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: " DOWN TIME",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Down Time",
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.timelapse,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: 80,
                            height: 60,
                            padding: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              value: downtimestatedropdownvalue,
                              alignment: Alignment.centerRight,
                              dropdownColor: C.theamecolor,
                              underline: Container(),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 40,
                              ),
                              items: downtimestate.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(
                                      color: C.textfromcolor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  downtimestatedropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                              bottom: 20,
                            ),
                            width: 155,
                            height: 60,
                            child: TextFormField(
                              controller: bustravlehrdowntimecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: " Travel time in hour",
                                hintStyle: TextStyle(
                                  color: C.textfromcolor,
                                  fontSize: 15,
                                ),
                                labelText: "Travel time in hour",
                                labelStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 0, bottom: 20),
                            width: 155,
                            height: 60,
                            child: TextFormField(
                              controller: bustravlemindowntimecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: "Travel time in minute",
                                hintStyle: TextStyle(
                                  color: C.textfromcolor,
                                  fontSize: 13,
                                ),
                                labelText: "Travel time in minute",
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              controller: busticketpricecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field required';
                                }

                                return null;
                              },
                              onChanged: (value) => ConfirmPassword = value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: " Ticket Price",
                                hintStyle: TextStyle(color: C.textfromcolor),
                                labelText: "Ticket Price",
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                prefixIcon: const Icon(
                                  Icons.currency_rupee_rounded,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: C.textfromcolor),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        height: 50,
                        width: 280,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          // ignore: sort_child_properties_last
                          child: const Text(
                            'SUBMIT',
                            style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: "mogra",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: C.theamecolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              voidlog(
                                adminnamecontroller.text,
                                adminphonecontroller.text,
                                adminemailcontroller.text,
                                adminpasswordcontroller.text,
                                busnamecontroller.text,
                                busnocontroller.text,
                                busseatcapacitycontroller.text,
                                bustyperadiobutton,
                                updepotsearchController.text,
                                busuptimecontroller.text +
                                    uptimestatedropdownvalue,
                                "${bustravlehruptimecontroller.text}hr${bustravleminuptimecontroller.text}min",
                                downdepotsearchController.text,
                                busdowntimecontroller.text +
                                    downtimestatedropdownvalue,
                                "${bustravlehrdowntimecontroller.text}hr${bustravlemindowntimecontroller.text}min",
                                busticketpricecontroller.text,
                              );
                              // var prefs = await SharedPreferences.getInstance();
                              // prefs.setBool(SplashscreenState.KEYLOGIN, true);
                            } else {
                              Fluttertoast.showToast(msg: "Please Enter all");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
