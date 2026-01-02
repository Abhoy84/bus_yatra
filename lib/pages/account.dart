import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/login.dart';

import '../utils/urlpage.dart';
import 'dart:io';

// ignore: must_be_immutable
class Account extends StatefulWidget {
  User user;
  Account(this.user, {super.key});

  @override
  State<Account> createState() => _AccountState(user);
}

class _AccountState extends State<Account> {
  File? pickedImage;
  late SharedPreferences sp;

  Future<void> detailsupdate(
    String temail,
    String firstname,
    String phone,
    String email,
    String userid,
  ) async {
    Map data = {
      "temail": temail,
      "firstname": firstname,
      "phone": phone,
      "email": email,
      "uid": userid
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
          .post(Uri.parse("${MyUrl.fullurl}student_update.php"), body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        sp = await SharedPreferences.getInstance();
        user.fname = namecontroller.text;
        user.phone = phonecontroller.text;
        sp.setString('fname', user.fname);
        sp.setString('phone', user.phone);
        setState(() {});
        Navigator.pop(context);
        Navigator.pop(context);

        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
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
        pickedImage = tempImage;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future createprofile(File Uphoto, String userid) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("${MyUrl.fullurl}update_profile.php"));

      request.files.add(http.MultipartFile.fromBytes(
          'image', Uphoto.readAsBytesSync(),
          filename: Uphoto.path.split("/").last));
      request.fields['uid'] = userid;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        sp = await SharedPreferences.getInstance();

        user.image = jsondata['imgtitle'];
        sp.setString("image", user.image);

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

  @override
  void initState() {
    super.initState();

    passwordcontroller.text = "********";
    emailcontroller.text = user.email;
    namecontroller.text = user.fname;

    phonecontroller.text = user.phone;
  }

  bool nametype = false;
  bool emailtype = false;
  bool phonetype = false;
  bool passtype = false;
  User user;
  _AccountState(this.user);
  bool isvisible = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  String password = '';
  String ConfirmPassword = '';
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (builder) => homepage(user)));
            },
          ),
          backgroundColor: C.theamecolor,
          title: Text(
            "Account",
            style: TextStyle(color: C.textfromcolor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showFullImageDialog();
                  },
                  child: SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        pickedImage != null
                            ? CircleAvatar(
                                radius: 70,
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 254, 254),
                                child: CircleAvatar(
                                  backgroundImage: FileImage(pickedImage!),
                                  radius: 65,
                                ),
                              )
                            : CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor:
                                      const Color.fromARGB(255, 212, 182, 182),
                                  backgroundImage: NetworkImage(
                                    MyUrl.fullurl + MyUrl.imageurl + user.image,
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 2,
                          left: 90,
                          child: CircleAvatar(
                            backgroundColor: C.theamecolor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              pickImage(ImageSource.camera)
                                                  .whenComplete(() {
                                                if (pickedImage != null) {
                                                  createprofile(
                                                      pickedImage!, user.uid);
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            child: const Text(
                                              'Choose from Camera',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              pickImage(ImageSource.gallery)
                                                  .whenComplete(() {
                                                if (pickedImage != null) {
                                                  createprofile(
                                                      pickedImage!, user.uid);
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor:
                                                    Colors.transparent),
                                            child: const Text(
                                              'Choose from Gallary',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Form(
                  key: formkey,
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.only(top: 60, left: 0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: C.theamecolor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 178),
                            width: 100,
                            child: const Text(
                              "User name",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  enabled: nametype,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  controller: namecontroller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cannot left Blank!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    fillColor: Color.fromARGB(0, 255, 255, 255),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.person_outlined,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    nametype = !nametype;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 178),
                            width: 100,
                            child: const Text(
                              "Email",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  enabled: emailtype,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  controller: emailcontroller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cannot left Blank!';
                                    } else if (!RegExp(
                                            r'[^0-9]+[a-zA-Z0-9]+@+gmail+\.+com')
                                        .hasMatch(value)) {
                                      return 'Please enter Valide email id';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    fillColor: Color.fromARGB(0, 255, 255, 255),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Warning!',
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.red),
                                        ),
                                        content: const Text(
                                          'If you change your E-mail.You must need relogin!',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              emailtype = false;
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'No',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              emailtype = true;
                                              Navigator.of(context).pop();
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
                                  setState(() {
                                    emailtype = !emailtype;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 178),
                            padding: const EdgeInsets.only(top: 0),
                            width: 100,
                            child: const Text(
                              "Phone no.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  enabled: phonetype,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  controller: phonecontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    fillColor: Color.fromARGB(0, 255, 255, 255),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.phone_android_outlined,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    phonetype = !phonetype;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 178),
                            width: 100,
                            child: const Text(
                              "Password",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                padding: const EdgeInsets.only(bottom: 30),
                                child: TextFormField(
                                  enabled: passtype,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  controller: passwordcontroller,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    fillColor: Color.fromARGB(0, 255, 255, 255),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 2,
                            ),
                            height: 50,
                            width: 200,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: C.theamecolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                              ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  detailsupdate(
                                          user.email,
                                          namecontroller.text,
                                          phonecontroller.text,
                                          emailcontroller.text,
                                          user.uid)
                                      .whenComplete(
                                    () {
                                      if (user.email != emailcontroller.text) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Warning!',
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.red),
                                              ),
                                              content: const Text(
                                                'Season expired !!',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    sp = await SharedPreferences
                                                        .getInstance();
                                                    sp.remove('loginkey');

                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login(),
                                                      ),
                                                    );
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
                                      }
                                    },
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Enter all");
                                }
                              },
                              child: const Text(
                                'DONE',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: "mogra"),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    backgroundColor: Colors.transparent,
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
