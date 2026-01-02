// import 'dart:js';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/account.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/login.dart';
import 'package:ticketbooking/pages/alltickets.dart';
import 'package:ticketbooking/utils/urlpage.dart';

// ignore: must_be_immutable
class Navbar extends StatefulWidget {
  User user;
  Navbar(this.user, {super.key});

  @override
  State<Navbar> createState() => _NavbarState(user);
}

class _NavbarState extends State<Navbar> {
  Widget showimage() {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      color: Colors.black,
      // child: Image.network(MyUrl.fullurl + MyUrl.imageurl + i),
    ));
  }

  String i = '';

  late SharedPreferences sp;
  User user;
  _NavbarState(this.user);

  @override
  void initState() {
    x().whenComplete(() {
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  Future x() async {
    sp = await SharedPreferences.getInstance();
    i = sp.getString("image") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 230,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: C.theamecolor,
              ),
              accountName: Text(user.fname),
              accountEmail: Text(user.email),
              currentAccountPictureSize: const Size.fromRadius(60),
              currentAccountPicture: Column(children: [
                Stack(
                  children: [
                    // user.image != null
                    InkWell(
                      onTap: () {
                        showFullImageDialog();
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 254, 254),
                        child: CircleAvatar(
                          // child: Image.file(pickedImage!),
                          backgroundImage: NetworkImage(
                            MyUrl.fullurl + MyUrl.imageurl + user.image,
                          ),
                          radius: 55,
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.only(
                      right: 0,
                    )),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => homepage(user),
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.home_filled),
                  title: Text("Home"),
                  // trailing: Icon(Icons.arrow_forward),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.only(
                      right: 0,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Account(user),
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Account"),
                  // trailing: Icon(Icons.arrow_forward),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.only(
                      right: 0,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => alltickets(),
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.book_online),
                  title: Text("Tickets"),
                  // trailing: Icon(Icons.arrow_forward),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.only(
                      right: 0,
                    )),
                onPressed: () async {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Logout!',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                        content: const Text(
                          'Are you sure?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // emailtype = false;
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var prefs = await SharedPreferences.getInstance();
                              prefs.remove('loginkey');
                              prefs.clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  // var prefs = await SharedPreferences.getInstance();
                  // prefs.remove('loginkey');
                },
                child: const ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text("Logout"),
                  // trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showFullImageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppBar(
                    iconTheme: IconThemeData(color: C.textfromcolor),
                    backgroundColor: const Color.fromARGB(0, 207, 18, 18),
                    elevation: 0,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 150),
                  width: 400,
                  height: 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      MyUrl.fullurl + MyUrl.imageurl + user.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
