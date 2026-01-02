import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/manageSeat.dart';

class Seatinfo extends StatefulWidget {
  const Seatinfo({super.key});

  @override
  State<Seatinfo> createState() => SeatinfoState();
}

class SeatinfoState extends State<Seatinfo> {
  static int row = 0;
  static int column = 0;
  TextEditingController rowcontroller = TextEditingController();
  TextEditingController columncontroller = TextEditingController();
  late SharedPreferences sp;
  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat Information"),
        backgroundColor: C.theamecolor,
        actions: const [],
      ),
      body: Container(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  // ignore: sort_child_properties_last

                  // heisght: 200,
                  ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: C.theamecolor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(60)),
                  ),
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  // decoration: BoxDecoration(
                  //   color: C.theamecolor,
                  // borderRadius: const BorderRadius.only(
                  //     topLeft: Radius.circular(60),
                  //     topRight: Radius.circular(60)),
                  // ),

                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 39,
                          vertical: 25,
                        ),
                        padding: const EdgeInsets.only(bottom: 0),
                        child: TextFormField(
                          controller: columncontroller,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Can't left blank";
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 3,
                              ),
                            ),
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
                            filled: true,
                            hintText: "Enter column number",
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            labelText: "column number",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            prefixIcon: const Icon(
                              Icons.view_column_rounded,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 39,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: rowcontroller,
                          // obscureText: type,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Column number required!';
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
                            filled: true,
                            hintText: "Enter row number",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            labelText: " row number ",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            prefixIcon: const Icon(
                              Icons.table_rows_rounded,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                width: 3,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 30,
                        ),
                        height: 60,
                        width: 270,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                            // ignore: sort_child_properties_last
                            child: Text(
                              "CREATE",
                              style: TextStyle(
                                  color: C.theamecolor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              backgroundColor: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              fixedSize: const Size(
                                300,
                                50,
                              ),
                            ),
                            onPressed: () async {
                              sp = await SharedPreferences.getInstance();
                              setState(() {
                                row = int.parse(rowcontroller.text);
                                column = int.parse(columncontroller.text);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => manageSeat()),
                                );
                              });
                              // if (formkey.currentState!.validate()) {
                              //   voidlog(useremailcontroller.text,
                              //       passwordcontroller.text);
                              //   var prefs =
                              //       await SharedPreferences.getInstance();
                              //   prefs.setBool(
                              //       SplashscreenState.KEYLOGIN, true);
                              // } else {
                              //   Fluttertoast.showToast(
                              //       msg:
                              //           "Please Enter Email id and Password");
                              // }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
