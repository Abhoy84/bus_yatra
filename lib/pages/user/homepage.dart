import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/busmodel.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/user/Navbar.dart';
import 'package:ticketbooking/pages/user/notification_page.dart';
import 'package:ticketbooking/pages/user/account.dart';
import 'package:ticketbooking/pages/user/alltickets.dart';
import 'package:ticketbooking/pages/user/buslist.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:ticketbooking/utils/urlpage.dart';
import 'package:ticketbooking/pages/user/support_page.dart';
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
    showdate = "${DateFormat('d MMM yyyy').format(currentdate)}";
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
        backgroundColor: Colors.grey[100],
        drawer: Navbar(user),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: C.theamecolor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  MyUrl.fullurl + MyUrl.imageurl + user.image,
                ),
                onBackgroundImageError: (_, __) =>
                    const Icon(Icons.person, color: Colors.white),
                backgroundColor: Colors.white.withOpacity(0.2),
                child: user.image.isEmpty
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${user.fname.split(' ')[0]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Where to next?",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: user.uid)
                  .where('isRead', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                bool hasUnread = false;
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  hasUnread = true;
                }

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                      },
                    ),
                    if (hasUnread)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: C.theamecolor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Search Planner "Card" - overlapping the colorful header if we wanted,
              // but for now let's keep it simple and clean below the appbar.
              Container(
                decoration: BoxDecoration(
                  color: C.theamecolor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 40,
                  top: 10,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              // FROM Input
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Autocomplete(
                                  key: keyUp,
                                  initialValue: TextEditingValue(
                                    text: updepotsearchController.text,
                                  ),
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
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
                                    updepotsearchController.text = item;
                                  },
                                  fieldViewBuilder:
                                      (
                                        context,
                                        controller,
                                        focusNode,
                                        onEditingComplete,
                                      ) {
                                        // Sync logic
                                        if (controller.text !=
                                            updepotsearchController.text) {
                                          controller.text =
                                              updepotsearchController.text;
                                        }
                                        updepotsearchController = controller;

                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.my_location,
                                              color: C.theamecolor,
                                            ),
                                            hintText: "From City",
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                ),
                                          ),
                                        );
                                      },
                                ),
                              ),
                              const Divider(height: 1),
                              // TO Input
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Autocomplete(
                                  key: keyDown,
                                  initialValue: TextEditingValue(
                                    text: downdepotsearchController.text,
                                  ),
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
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
                                    downdepotsearchController.text = item;
                                  },
                                  fieldViewBuilder:
                                      (
                                        context,
                                        controller,
                                        focusNode,
                                        onEditingComplete,
                                      ) {
                                        // Sync logic
                                        if (controller.text !=
                                            downdepotsearchController.text) {
                                          controller.text =
                                              downdepotsearchController.text;
                                        }
                                        downdepotsearchController = controller;

                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onEditingComplete,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.location_on,
                                              color: C.theamecolor,
                                            ),
                                            hintText: "To City",
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                ),
                                          ),
                                        );
                                      },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Swap Button
                        Positioned(
                          right: 20,
                          top: 45, // Halfway roughly
                          child: InkWell(
                            onTap: _swapLocations,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: C.theamecolor,
                              child: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Date Picker
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
                                "${DateFormat('d MMM yyyy').format(pickdate)}";
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white54),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              viewdate ?? "Select Date",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          if (updepotsearchController.text.isNotEmpty &&
                              downdepotsearchController.text.isNotEmpty) {
                            // Validation logic manually since we are using Autocomplete which is tricky with Form
                            // Using text check primarily
                            sp = await SharedPreferences.getInstance();
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
                                builder: (context) => const buslistpage(),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please select both locations",
                            );
                          }
                        },
                        child: Text(
                          'SEARCH BUSES',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: C.theamecolor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 2. Quick Actions Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 3. Grid of Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionCard(
                      icon: Icons.confirmation_number_outlined,
                      label: "My Tickets",
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
                      icon: Icons.person_outline,
                      label: "Profile",
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
                      icon: Icons.support_agent,
                      label: "Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 4. Promo Banner (Carousel)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Special Offers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(imageList[index]['image_path']),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
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
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: C.theamecolor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: C.theamecolor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
