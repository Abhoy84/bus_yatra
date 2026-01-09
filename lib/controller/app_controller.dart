import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketbooking/pages/admin/adminlogin.dart';
import 'package:ticketbooking/pages/common/loadingdialoge.dart';

class AppController extends GetxController {
  // Observables for Admin Sign In
  var bustyperadiobutton = 'A/C'.obs;
  var uptimestatedropdownvalue = "am".obs;
  var downtimestatedropdownvalue = "am".obs;

  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;

  // Observables for Location Autocomplete
  var isLoadingUp = false.obs;
  var isLoadingDown = false.obs;
  var isLoading = false.obs; // General loading state

  // Text Controllers
  final TextEditingController adminnamecontroller = TextEditingController();
  final TextEditingController adminphonecontroller = TextEditingController();
  final TextEditingController adminemailcontroller = TextEditingController();
  final TextEditingController adminpasswordcontroller = TextEditingController();
  final TextEditingController adminconfirmpasswordcontroller =
      TextEditingController();

  final TextEditingController busnamecontroller = TextEditingController();
  final TextEditingController busnocontroller = TextEditingController();
  final TextEditingController busseatcapacitycontroller =
      TextEditingController();

  final TextEditingController busuptimecontroller = TextEditingController();
  final TextEditingController bustravleminuptimecontroller =
      TextEditingController();
  final TextEditingController bustravlehruptimecontroller =
      TextEditingController();

  final TextEditingController busdowntimecontroller = TextEditingController();
  final TextEditingController bustravlehrdowntimecontroller =
      TextEditingController();
  final TextEditingController bustravlemindowntimecontroller =
      TextEditingController();

  final TextEditingController updepotsearchController = TextEditingController();
  final TextEditingController downdepotsearchController =
      TextEditingController();
  final TextEditingController busticketpricecontroller =
      TextEditingController();

  // Methods
  void setBusType(String val) {
    bustyperadiobutton.value = val;
  }

  void setUpTimeState(String val) {
    uptimestatedropdownvalue.value = val;
  }

  void setDownTimeState(String val) {
    downtimestatedropdownvalue.value = val;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Create Admin Account (Migrated from Adminsign.dart)
  Future<void> createAdminAccount(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: adminemailcontroller.text.trim(),
            password: adminpasswordcontroller.text.trim(),
          );

      String uid = userCredential.user!.uid;

      Map<String, dynamic> busData = {
        "admin_id": uid,
        "name": adminnamecontroller.text.trim(),
        "phone": adminphonecontroller.text.trim(),
        "email": adminemailcontroller.text.trim(),
        "busname": busnamecontroller.text.trim(),
        "regno": busnocontroller.text.trim(),
        "seatno": busseatcapacitycontroller.text.trim(),
        "type": bustyperadiobutton.value,
        "updepot": updepotsearchController.text.trim(),
        "uptime":
            "${busuptimecontroller.text}:${bustravleminuptimecontroller.text} ${uptimestatedropdownvalue.value}",
        "uptvtime": bustravlehruptimecontroller.text.trim(),
        "downdepot": downdepotsearchController.text.trim(),
        "downtime":
            "${busdowntimecontroller.text}:${bustravlemindowntimecontroller.text} ${downtimestatedropdownvalue.value}",
        "downtvtime": bustravlehrdowntimecontroller.text.trim(),
        "ticketprice": busticketpricecontroller.text.trim(),
        "busimage": "default.png",
        "busstatus": "active",
        "created_at": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('buses')
          .doc(uid)
          .set(busData);

      Navigator.pop(context); // Close Dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Adminlogin()),
      );
      Fluttertoast.showToast(msg: "Account Created Successfully!");
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close Dialog on Error
      Fluttertoast.showToast(msg: e.message ?? "Auth Error");
    } catch (e) {
      Navigator.pop(context); // Close Dialog on Error
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // API Fetch Logic
  Future<List<String>> fetchLocations(String query, RxBool loader) async {
    if (query.isEmpty) return [];

    loader.value = true;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=15&countrycodes=in',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'com.example.ticketbooking'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => item['display_name'] as String).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Network Error: $e");
      return [];
    } finally {
      loader.value = false;
    }
  }

  // --- Seat Layout Logic ---
  var totalRows = 10.obs;
  var totalCols = 4.obs;
  var inactiveSeats = <int>{}.obs;

  void toggleSeatStatus(int index) {
    if (inactiveSeats.contains(index)) {
      inactiveSeats.remove(index);
      print("Removed seat $index from inactive. Current: $inactiveSeats");
    } else {
      inactiveSeats.add(index);
      print("Added seat $index to inactive. Current: $inactiveSeats");
    }
    inactiveSeats.refresh(); // Explicitly notifying listeners just in case
  }

  Future<void> updateAdminProfile({
    required String name,
    required String phone,
    required String email,
    required String passcode,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Fluttertoast.showToast(msg: "Error: Not logged in");
        return;
      }

      isLoading.value = true;

      // Update Firestore
      await FirebaseFirestore.instance.collection('buses').doc(user.uid).update(
        {'name': name, 'phone': phone, 'email': email, 'passcode': passcode},
      );

      // Update Local Preferences (maintaining legacy support)
      final sp = await SharedPreferences.getInstance();
      await sp.setString('adminname', name);
      await sp.setString('adminphone', phone);
      await sp.setString('adminemail', email);
      await sp.setString('adminpasscode', passcode);

      isLoading.value = false;
      Fluttertoast.showToast(msg: "Profile Updated Successfully!");
      Get.back(); // Close the page
    } catch (e) {
      isLoading.value = false;
      print("Error updating profile: $e");
      Fluttertoast.showToast(msg: "Update failed: $e");
    }
  }

  Future<void> loadSeatLayout(String busId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('buses')
          .doc(busId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Load inactive seats
        List<dynamic> inactiveList = data['inactive_seats'] ?? [];
        inactiveSeats.assignAll(inactiveList.map((e) => e as int).toSet());

        // Load dimensions if they exist (optional, mostly defaults)
        // totalRows.value = int.parse(data['rows'] ?? "10");
        // totalCols.value = int.parse(data['cols'] ?? "4");
      }
    } catch (e) {
      print("Error loading seats: $e");
    }
  }

  Future<void> saveSeatLayout(BuildContext context, String busId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(),
    );

    try {
      await FirebaseFirestore.instance.collection('buses').doc(busId).update({
        'inactive_seats': inactiveSeats.toList(),
        // 'rows': totalRows.value.toString(), // Optional if we want dynamic dimensions later
        // 'cols': totalCols.value.toString(),
      });

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Layout Saved Successfully!");
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error saving layout: $e");
    }
  }
}
