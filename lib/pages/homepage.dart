import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/busmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/Navbar.dart';
import 'package:ticketbooking/pages/account.dart';
import 'package:ticketbooking/pages/alltickets.dart';
import 'package:ticketbooking/pages/buslist.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/utils/urlpage.dart';
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

  // Keys to force rebuild of Autocomplete widgets on swap
  Key keyUp = UniqueKey();
  Key keyDown = UniqueKey();

  void _swapLocations() {
    if (updepotsearchController.text.isEmpty &&
        downdepotsearchController.text.isEmpty)
      return;

    setState(() {
      String temp = updepotsearchController.text;
      updepotsearchController.text = downdepotsearchController.text;
      downdepotsearchController.text = temp;

      // Force rebuild to update initialValue
      keyUp = UniqueKey();
      keyDown = UniqueKey();
    });
  }

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

  Future getdepot() async {
    try {
      // Query the 'buses' collection instead of 'depots'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('buses')
          .get();

      if (snapshot.docs.isNotEmpty) {
        Depotlist.clear();
        Depotidlist.clear();
        Set<String> uniqueDepots = {};

        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Extract both Up and Down depots
          String up = data['updepot'] ?? '';
          String down = data['downdepot'] ?? '';

          if (up.isNotEmpty) uniqueDepots.add(up);
          if (down.isNotEmpty) uniqueDepots.add(down);
        }

        // Convert Set to List and sort
        Depotlist = uniqueDepots.toList()..sort();

        // Populate Depotidlist with dummy data to maintain list length sync if needed (legacy)
        // or just ignore it if unused. For safety, matching length.
        for (var _ in Depotlist) {
          Depotidlist.add('bus_derived_id');
        }

        filterDepotlist = Depotlist;
        setState(() {});
      } else {
        Depotlist.clear();
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
        backgroundColor: const Color(0xFFF5F7FA), // Very light cool grey
        drawer: Navbar(user),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER SECTION
              Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: C.theamecolor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        // AppBar content manually placed for layout control
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Hello, ${user.fname.split(' ')[0]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Ready to travel?",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      MyUrl.fullurl +
                                          MyUrl.imageurl +
                                          user.image,
                                    ),
                                    onBackgroundImageError: (_, __) =>
                                        const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    child: user.image.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // 2. SEARCH CARD
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Inputs Stack
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      // FROM Field
                                      _buildLocationInput(
                                        controller: updepotsearchController,
                                        hint: "From",
                                        icon: Icons.my_location,
                                        isUp: true,
                                      ),
                                      const SizedBox(height: 15),
                                      // TO Field
                                      _buildLocationInput(
                                        controller: downdepotsearchController,
                                        hint: "To",
                                        icon: Icons.location_on,
                                        isUp: false,
                                      ),
                                    ],
                                  ),
                                  // Floating Swap Button
                                  Positioned(
                                    right: 40,
                                    top: 38, // Adjusted for spacing
                                    child: InkWell(
                                      onTap: _swapLocations,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.grey[100]!,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.swap_vert_rounded,
                                          color: C.theamecolor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              // Date Selection
                              InkWell(
                                onTap: () async {
                                  DateTime? pickdate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050),
                                  );
                                  if (pickdate != null) {
                                    setState(() {
                                      viewdate =
                                          "  ${DateFormat('yMMMEd').format(pickdate)}";
                                      showdate =
                                          "${DateFormat('yMd').format(pickdate)}";
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Journey Date",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            viewdate?.trim() ?? "Select Date",
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Search Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: C.theamecolor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 8,
                                    shadowColor: C.theamecolor.withOpacity(0.5),
                                  ),
                                  onPressed: () async {
                                    if (formkey.currentState!.validate() ||
                                        (updepotsearchController
                                                .text
                                                .isNotEmpty &&
                                            downdepotsearchController
                                                .text
                                                .isNotEmpty)) {
                                      sp =
                                          await SharedPreferences.getInstance();
                                      sp.setString(
                                        'pickuppoint',
                                        updepotsearchController.text,
                                      );
                                      sp.setString(
                                        'destination',
                                        downdepotsearchController.text,
                                      );

                                      setState(() {});

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const buslistpage(),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please select both locations",
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'SEARCH BUSES',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
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

              const SizedBox(height: 10),

              // 3. QUICK ACTIONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionCard(
                      icon: Icons.confirmation_number_rounded,
                      label: "My Tickets",
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const alltickets(),
                          ),
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.person_rounded,
                      label: "Profile",
                      color: Colors.deepPurpleAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Account(user),
                          ),
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.headset_mic_rounded,
                      label: "Support",
                      color: Colors.teal,
                      onTap: () {
                        Fluttertoast.showToast(msg: "Support coming soon!");
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 4. PROMO SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Special Offers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: C.theamecolor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 15, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(imageList[index]['image_path']),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 5. HELPER WIDGETS
  Widget _buildLocationInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isUp,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Autocomplete(
        key: isUp ? keyUp : keyDown,
        initialValue: TextEditingValue(text: controller.text),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return Iterable<String>.empty();
          }
          return Depotlist.where((String item) {
            return item.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        },
        onSelected: (String item) {
          controller.text = item;
        },
        fieldViewBuilder:
            (context, fieldController, focusNode, onEditingComplete) {
              // Sync logic
              if (fieldController.text != controller.text) {
                fieldController.text = controller.text;
              }
              if (isUp) {
                updepotsearchController = fieldController;
              } else {
                downdepotsearchController = fieldController;
              }

              return TextField(
                controller: fieldController,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: C.theamecolor, size: 20),
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              );
            },
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
