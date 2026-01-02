import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/busmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/Navbar.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class homepage extends StatefulWidget {
  User user;
  homepage(this.user);

  @override
  State<homepage> createState() => homepageState(user);
}

class homepageState extends State<homepage> with TickerProviderStateMixin {
  User user;
  homepageState(this.user);
  static User? pass;
  late SharedPreferences sp;
  GlobalKey<FormState> formkey = GlobalKey();
  List imageList = [
    {"id": 1, "image_path": 'asset/image/p1.png'},
    {"id": 2, "image_path": 'asset/image/p2.jpg'},
    {"id": 3, "image_path": 'asset/image/p3.webp'},
    {"id": 4, "image_path": 'asset/image/p4.png'},
    {"id": 5, "image_path": 'asset/image/p5.webp'},
  ];
  List<String> items = [];
  List<String> filteredItems = [];
  bool updepotshowList = false;
  bool downdepotshowList = false;
  // final carousel_slider.CarouselSliderController carouselController =
  //     carousel_slider.CarouselSliderController();
  int currentIndex = 0;
  List<Bus> buslist = [];
  late AnimationController _controller;
  List<String> Depotlist = [];
  List<String> filterDepotlist = [];
  static String? showdate;
  String? viewdate;
  DateTime currentdate = DateTime.now();

  List<String> Depotidlist = [];

  TextEditingController updepotsearchController = TextEditingController();
  TextEditingController downdepotsearchController = TextEditingController();
  @override
  void initState() {
    swaping();

    // TODO: implement initState
    super.initState();
    getdepot();
    // updepotsearchController.text = "From";
    setdate().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> setdate() async {
    viewdate = "  ${DateFormat('yMMMEd').format(currentdate)}";
    showdate = "  ${DateFormat('yMd').format(currentdate)}";
  }

  void _filterItems(String query) {
    query = query.toLowerCase();
    setState(() {
      filterDepotlist = Depotlist.where(
        (item) => item.toLowerCase().contains(query),
      ).toList();
    });
  }

  Future getdepot() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('depots')
          .get();

      if (snapshot.docs.isNotEmpty) {
        Depotlist.clear();
        Depotidlist.clear();

        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String name = data['depot_name'] ?? '';
          // Use doc.id as depot_id if not present, or valid field.
          // Existing code expects int ID, but list is String.
          // Storing doc ID as String in Depotidlist.

          Depotlist.add(name.toLowerCase());
          Depotidlist.add(doc.id);
        }
        filterDepotlist = Depotlist;
        setState(() {});
      } else {
        // Fallback or empty state
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> swaping() async {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Navbar(user),
        appBar: AppBar(
          iconTheme: IconThemeData(color: C.textfromcolor),
          backgroundColor: C.theamecolor,
          title: Text("WELCOME", style: TextStyle(color: C.textfromcolor)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 70,
                          width: 350,
                          padding: EdgeInsets.only(left: 0, top: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Autocomplete(
                            // initialValue: updepotsearchController.value,
                            fieldViewBuilder:
                                ((
                                  context,
                                  updepotsearchController,
                                  focusNode,
                                  onEditingComplete,
                                ) {
                                  return TextFormField(
                                    onTap: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "select the pickup location";
                                      } else {
                                        return null;
                                      }
                                    },
                                    // expands: true,
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: updepotsearchController,
                                    focusNode: focusNode,
                                    onEditingComplete: onEditingComplete,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintText: "From",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.directions_bus_filled,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        size: 30,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(0, 210, 22, 22),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(0, 231, 27, 27),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  );
                                }),

                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return Iterable<String>.empty();
                                  }
                                  return Depotlist.where((String item) {
                                    return item.contains(textEditingValue.text);
                                  });
                                },

                            onSelected: (String item) {
                              updepotsearchController.text = item;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(),
                          height: 70,
                          width: 350,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.black, width: 1),
                              right: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: Autocomplete(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue == '') {
                                    return Iterable<String>.empty();
                                  }
                                  return Depotlist.where((String item) {
                                    return item.contains(textEditingValue.text);
                                  });
                                },
                            onSelected: (String item) {
                              downdepotsearchController.text = item;
                            },
                            fieldViewBuilder:
                                ((
                                  context,
                                  downdepotsearchController,
                                  focusNode,
                                  onEditingComplete,
                                ) {
                                  return TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "select destinetion!";
                                      } else {
                                        return null;
                                      }
                                    },
                                    focusNode: focusNode,
                                    onEditingComplete: onEditingComplete,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: downdepotsearchController,
                                    // onChanged: _filterItems,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        left: 20,
                                        top: 30,
                                      ),
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      hintText: "To",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.directions_bus_filled,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        size: 30,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(0, 210, 22, 22),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(0, 231, 27, 27),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime? pickdate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                            );
                            if (pickdate != null) {
                              viewdate =
                                  "  ${DateFormat('yMMMd').format(pickdate)}";
                              showdate =
                                  "${DateFormat('yMd').format(pickdate)}";
                            } else {
                              viewdate =
                                  "  ${DateFormat('yMMMEd').format(currentdate)}";
                              showdate =
                                  "${DateFormat('yMd').format(currentdate)}";
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 70,
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, size: 30),
                                Text(
                                  viewdate!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 60,
                width: 380,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    'SEARCH BUS',
                    style: TextStyle(
                      fontSize: 23,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.theamecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      sp = await SharedPreferences.getInstance();
                      sp.setString('pickuppoint', updepotsearchController.text);
                      sp.setString(
                        'destination',
                        downdepotsearchController.text,
                      );

                      setState(() {});

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => buslistpage()),
                      );
                    }
                  },
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: Stack(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           print(currentIndex);
              //         },
              //         child: carousel_slider.CarouselSlider(
              //           items: imageList
              //               .map(
              //                 (item) => Image.asset(
              //                   item['image_path'],
              //                   fit: BoxFit.cover,
              //                   width: double.infinity,
              //                 ),
              //               )
              //               .toList(),
              //           carouselController: carouselController,
              //           options: carousel_slider.CarouselOptions(
              //             scrollPhysics: const BouncingScrollPhysics(),
              //             autoPlay: true,
              //             aspectRatio: 2,
              //             viewportFraction: 1,
              //             onPageChanged: (index, reason) {
              //               setState(() {
              //                 currentIndex = index;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Positioned(
              //         // top: 0,
              //         bottom: 5,
              //         left: 0,
              //         right: 0,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: imageList.asMap().entries.map((entry) {
              //             return GestureDetector(
              //               onTap: () =>
              //                   carouselController.animateToPage(entry.key),
              //               child: Container(
              //                 width: currentIndex == entry.key ? 20 : 10,
              //                 height: 10,
              //                 margin:
              //                     const EdgeInsets.symmetric(horizontal: 3.0),
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     color: currentIndex == entry.key
              //                         ? Color.fromARGB(255, 251, 170, 30)
              //                         : Colors.white),
              //               ),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void depotswaping(String from, String to) {
    String temp = from;
    updepotsearchController.text = to;

    downdepotsearchController.text = temp;
  }

  Widget buildContainer() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.blue,
      child: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
