// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ticketbooking/pages/common/color.dart';
// import 'package:ticketbooking/pages/common/loadingdialoge.dart';
// import 'package:ticketbooking/pages/user/login.dart';

// class Signup extends StatefulWidget {
//   const Signup({super.key});

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   bool isvisible = false;
//   bool type = true;
//   bool type1 = true;
//   TextEditingController Fristnamecontroller = TextEditingController();
//   TextEditingController Phonecontroller = TextEditingController();
//   TextEditingController Emailcontroller = TextEditingController();
//   TextEditingController Passwordcontroller = TextEditingController();
//   TextEditingController confirmPasswordcontroller = TextEditingController();
//   GlobalKey<FormState> formkey = GlobalKey();
//   String password = '';
//   String ConfirmPassword = '';

//   Future<void> voidlog(
//     String firstname,
//     String phone,
//     String email,
//     String password,
//   ) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return const LoadingDialog();
//       },
//     );
//     try {
//       // Check for duplicate phone number
//       QuerySnapshot phoneSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('phone', isEqualTo: phone)
//           .get();

//       if (phoneSnapshot.docs.isNotEmpty) {
//         Navigator.pop(context);
//         Fluttertoast.showToast(msg: "Phone number already registered!");
//         return;
//       }

//       // Create user in Firebase Auth
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       // Save user details to Firestore
//       String uid = userCredential.user!.uid;
//       await FirebaseFirestore.instance.collection('users').doc(uid).set({
//         'fname': firstname,
//         'phone': phone,
//         'email': email,
//         'uid': uid,
//         'image': '', // Placeholder for image
//         'created_at': FieldValue.serverTimestamp(),
//       });

//       Navigator.pop(context); // Close loading dialog
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
//       Fluttertoast.showToast(msg: "Registration Successful");
//     } on FirebaseAuthException catch (e) {
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: e.message ?? "Registration failed");
//     } catch (e) {
//       Navigator.pop(context);
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: C.theamecolor,
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Form(
//             key: formkey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 50),
//                         child: CircleAvatar(
//                           radius: 55,
//                           backgroundColor: Colors.white,
//                           child: CircleAvatar(
//                             radius: 50,
//                             backgroundColor: const Color.fromARGB(
//                               255,
//                               255,
//                               255,
//                               255,
//                             ),
//                             child: Image.asset(
//                               "asset/image/buslogo2.png",
//                               scale: 2.5,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 100, top: 30),
//                         child: Container(
//                           height: 50,
//                           width: 200,
//                           margin: const EdgeInsets.only(),
//                           child: AnimatedTextKit(
//                             animatedTexts: [
//                               ColorizeAnimatedText(
//                                 "Sign Up!",
//                                 speed: const Duration(seconds: 1),
//                                 textStyle: const TextStyle(
//                                   color: Color.fromARGB(255, 254, 254, 254),
//                                   fontFamily: "lobster",
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 colors: [
//                                   const Color.fromARGB(255, 255, 255, 255),
//                                   Colors.yellow,
//                                   const Color.fromARGB(255, 255, 255, 255),
//                                 ],
//                               ),
//                             ],
//                             pause: const Duration(milliseconds: 100),
//                             repeatForever: true,
//                             isRepeatingAnimation: true,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       // left: 30,
//                       top: 30,
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 320,
//                               height: 100,
//                               child: TextFormField(
//                                 controller: Fristnamecontroller,
//                                 validator: (value) {
//                                   if (value!.isEmpty) {
//                                     return 'Cannot left Blank!';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                                 autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   fillColor: Colors.transparent,
//                                   filled: true,
//                                   hintText: "FULL NAME",
//                                   labelText: "Full name ",
//                                   labelStyle: TextStyle(
//                                     color: C.fromfeildcolor,
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.person_2_outlined,
//                                     color: Colors.white,
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: C.fromfeildcolor,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: C.fromfeildcolor,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                                 style: TextStyle(color: C.textfromcolor),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 320,
//                               height: 100,
//                               child: TextFormField(
//                                 keyboardType: TextInputType.number,
//                                 controller: Phonecontroller,
//                                 validator: (value) {
//                                   if (value!.isEmpty) {
//                                     return 'Cannot left Blank!';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                                 autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   fillColor: Colors.transparent,
//                                   filled: true,
//                                   hintText: "PHONE NUMBER",
//                                   labelText: "Phone number ",
//                                   labelStyle: TextStyle(
//                                     color: C.fromfeildcolor,
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.phone_android_outlined,
//                                     color: Colors.white,
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: C.fromfeildcolor,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: C.fromfeildcolor,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                                 style: TextStyle(color: C.textfromcolor),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 320,
//                         height: 100,
//                         child: TextFormField(
//                           controller: Emailcontroller,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Cannot left Blank!';
//                             } else if (!RegExp(
//                               r'[^0-9]+[a-zA-Z0-9]+@+gmail+\.+com',
//                             ).hasMatch(value)) {
//                               return 'Please enter Valide email id';
//                             } else {
//                               return null;
//                             }
//                           },
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             fillColor: Colors.transparent,
//                             filled: true,
//                             hintText: "ENTER MAIL ID",
//                             labelText: "e-mail id ",
//                             labelStyle: TextStyle(color: C.fromfeildcolor),
//                             prefixIcon: const Icon(
//                               Icons.mail_outline_rounded,
//                               color: Color.fromARGB(255, 255, 255, 255),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: C.fromfeildcolor),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: C.fromfeildcolor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           style: TextStyle(color: C.textfromcolor),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 320,
//                         height: 100,
//                         child: TextFormField(
//                           controller: Passwordcontroller,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return ' Password Requried!';
//                             }
//                             if (value.trim().length <= 7) {
//                               return "Contains atleast 8 characters";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) => password = value,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           keyboardType: TextInputType.visiblePassword,
//                           obscureText: type,
//                           obscuringCharacter: '*',
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             fillColor: Colors.transparent,
//                             filled: true,
//                             hintText: "ENTER PASSWORD",
//                             labelText: " Create Password",
//                             labelStyle: TextStyle(color: C.fromfeildcolor),
//                             prefixIcon: const Icon(
//                               Icons.lock_outline_rounded,
//                               color: Color.fromARGB(255, 255, 255, 255),
//                             ),
//                             suffixIcon: TextButton(
//                               child: type
//                                   ? const Icon(
//                                       Icons.visibility_off,
//                                       color: Color.fromARGB(255, 255, 255, 255),
//                                     )
//                                   : const Icon(
//                                       Icons.visibility,
//                                       color: Color.fromARGB(255, 255, 255, 255),
//                                     ),
//                               onPressed: () {
//                                 setState(() {
//                                   type = !type;
//                                 });
//                               },
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: C.fromfeildcolor),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: C.fromfeildcolor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           style: TextStyle(color: C.textfromcolor),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 320,
//                         height: 100,
//                         child: TextFormField(
//                           controller: confirmPasswordcontroller,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'field required';
//                             }
//                             if (value != password) {
//                               return 'Confimation password does not match';
//                             }
//                             return null;
//                           },
//                           onChanged: (value) => ConfirmPassword = value,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           keyboardType: TextInputType.visiblePassword,
//                           obscureText: type1,
//                           obscuringCharacter: '*',
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             fillColor: Colors.transparent,
//                             filled: true,
//                             hintText: "CONFIRM PASSWORD",
//                             labelText: "Confirm password",
//                             labelStyle: const TextStyle(
//                               color: Color.fromARGB(255, 255, 255, 255),
//                             ),
//                             prefixIcon: const Icon(
//                               Icons.check_box_outlined,
//                               color: Color.fromARGB(255, 255, 255, 255),
//                             ),
//                             suffixIcon: TextButton(
//                               child: type1
//                                   ? const Icon(
//                                       Icons.visibility_off,
//                                       color: Color.fromARGB(255, 255, 255, 255),
//                                     )
//                                   : const Icon(
//                                       Icons.visibility,
//                                       color: Color.fromARGB(255, 255, 255, 255),
//                                     ),
//                               onPressed: () {
//                                 setState(() {
//                                   type1 = !type1;
//                                 });
//                               },
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           style: TextStyle(color: C.textfromcolor),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 0),
//                     height: 50,
//                     width: 280,
//                     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     child: ElevatedButton(
//                       // ignore: sort_child_properties_last
//                       child: const Text(
//                         'SUBMIT',
//                         style: TextStyle(
//                           fontSize: 25,
//                           color: Color.fromARGB(255, 255, 255, 255),
//                           fontFamily: "mogra",
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: C.theamecolor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           side: const BorderSide(color: Colors.white, width: 2),
//                         ),
//                       ),
//                       onPressed: () {
//                         if (formkey.currentState!.validate()) {
//                           voidlog(
//                             Fristnamecontroller.text,
//                             Phonecontroller.text,
//                             Emailcontroller.text,
//                             Passwordcontroller.text,
//                           );
//                           // var prefs = await SharedPreferences.getInstance();
//                           // prefs.setBool(SplashscreenState.KEYLOGIN, true);
//                         } else {
//                           Fluttertoast.showToast(msg: "Please Enter all");
//                         }
//                         //  Navigator.pushReplacement(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //       builder: (context) => Login(),
//                         //     ),
//                         //   );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
