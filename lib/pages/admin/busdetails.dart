// ignore_for_file: prefer_const_constructors

import 'dart:convert';
// import 'dart:html';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketbooking/models/adminmodel.dart';
import 'package:ticketbooking/pages/common/color.dart';
import 'package:ticketbooking/pages/common/loadingdialoge.dart';

import 'package:http/http.dart' as http;
import 'package:ticketbooking/utils/urlpage.dart';
import 'dart:ui';
// import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  TextEditingController uptimecontroller = TextEditingController();
  TextEditingController downdepotcontroller = TextEditingController();
  TextEditingController downtimecontroller = TextEditingController();
  TextEditingController uptvtimecontroller = TextEditingController();
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
    uptimecontroller.text = admin.uptime;
    downdepotcontroller.text = admin.downdepot;
    downtimecontroller.text = admin.downtime;
    uptvtimecontroller.text = admin.uptvtime;
    ticketpricecontroller.text = admin.ticketprice;
    statuscheck();
    _fetchLatestData();
  }

  Future<void> _fetchLatestData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('buses')
          .doc(uid)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            if (data.containsKey('seatno')) {
              var s = data['seatno'];
              admin.seatno = s.toString();
              busseatnocontroller.text = admin.seatno;
            }
            // Refresh other fields if needed to ensure consistency
            if (data.containsKey('busname')) admin.busname = data['busname'];
            if (data.containsKey('regno')) admin.regno = data['regno'];
            if (data.containsKey('type')) admin.type = data['type'];

            // Update controllers just in case
            busseatnocontroller.text = admin.seatno;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching latest bus data: $e");
    }
  }

  Future<void> updateBusData(String field, String value) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('buses').doc(uid).update({
          field: value,
        });

        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Updated Successfully");
        setState(() {
          // Update local admin object so UI reflects changes immediately
          if (field == 'name') admin.name = value;
          if (field == 'busname') admin.busname = value;
          if (field == 'regno') admin.regno = value;
          // seatno is not editable
          if (field == 'type') admin.type = value;
          if (field == 'updepot') admin.updepot = value;
          if (field == 'uptime') admin.uptime = value;
          if (field == 'uptvtime') admin.uptvtime = value;
          if (field == 'downdepot') admin.downdepot = value;
          if (field == 'downtime') admin.downtime = value;
          if (field == 'downtvtime') admin.downtvtime = value;
          if (field == 'ticketprice') admin.ticketprice = value;
          if (field == 'busstatus') admin.status = value;
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "User not logged in");
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Update Failed: $e");
    }
  }

  void showEditDialog(
    String title,
    TextEditingController controller,
    String fieldKey,
  ) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          actions: [
            Form(
              key:
                  formkey, // Note: Sharing formKey might be risky if multiple dialogs open, but ok for modal
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Cannot be empty!';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  updateBusData(fieldKey, controller.text);
                }
              },
              child: const Text('Update', style: TextStyle(fontSize: 17)),
            ),
          ],
        );
      },
    );
  }

  void _showStatusReasonDialog() {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reason for Deactivation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please specify why you are turning off the bus status.",
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  hintText: "Enter Reason",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  _updateStatusWithReason('0', reasonController.text.trim());
                } else {
                  Fluttertoast.showToast(msg: "Please enter a reason");
                }
              },
              child: const Text("Deactivate"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateStatusWithReason(String newStatus, String reason) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('buses').doc(uid).update({
          'busstatus': newStatus,
          'statusReason': reason,
        });

        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Status Updated Successfully");
        setState(() {
          admin.status = newStatus;
          admin.statusReason = reason;
          statuscheck();
        });
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Update Failed: $e");
    }
  }

  void _showBusTypeEditDialog() {
    String selectedType = admin.type.isEmpty ? "AC" : admin.type;
    // Normalize logic if needed, assuming simple equality check works

    showDialog(
      context: context,
      barrierDismissible: true, // Allow cancelling by clicking outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text(
                "Select Bus Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text("AC"),
                    value: "AC",
                    groupValue: selectedType,
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedType = val!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Non AC"),
                    value: "Non AC",
                    groupValue: selectedType,
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedType = val!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    updateBusData('type', selectedType);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showTimeEditDialog(String fieldKey) async {
    TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: C.theamecolor,
            colorScheme: ColorScheme.light(primary: C.theamecolor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // 12-hour format: 10:30 AM
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'am' : 'pm';
      final formattedTime = "$hour:$minute $period";

      updateBusData(fieldKey, formattedTime);
    }
  }

  void _showTravelTimeEditDialog(String fieldKey) {
    TextEditingController hoursController = TextEditingController();
    TextEditingController minsController = TextEditingController();

    // Attempt to pre-fill if data exists in format "X Hours Y Mins"
    // This is optional but nice for UX.
    // Assuming format "5 Hours 30 Mins"
    try {
      String currentVal = (fieldKey == 'uptvtime')
          ? admin.uptvtime
          : admin.downtvtime; // handle both if needed later
      // currentVal = admin.uptvtime; // simplified
      if (currentVal.isNotEmpty) {
        final parts = currentVal.split(' ');
        if (parts.length >= 4) {
          hoursController.text = parts[0];
          minsController.text = parts[2];
        }
      }
    } catch (_) {}

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Travel Time"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hours",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: minsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Mins",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String hours = hoursController.text.trim();
                String mins = minsController.text.trim();

                if (hours.isEmpty) hours = "0";
                if (mins.isEmpty) mins = "0";

                String formattedDuration = "$hours Hours $mins Mins";
                Navigator.pop(context);
                updateBusData(fieldKey, formattedDuration);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
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

  Widget _buildInfoTile({
    required String label,
    required String value,
    VoidCallback? onEdit,
    bool isEditable = true,
    IconData icon = Icons.info_outline,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: isEditable ? onEdit : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: C.theamecolor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEditable)
                Icon(Icons.edit, color: Colors.grey.shade400, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: C.theamecolor,
        title: const Text(
          "Bus Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Text(
                  type ? "Active" : "Inactive",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: type,
                  activeColor: Colors.greenAccent,
                  activeTrackColor: Colors.white24,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.white24,
                  onChanged: (val) {
                    if (val) {
                      // Turning ON
                      updateBusData('busstatus', '1').whenComplete(() {
                        statuscheck();
                      });
                    } else {
                      // Turning OFF - Ask for reason
                      _showStatusReasonDialog();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Basic Information"),

              _buildInfoTile(
                label: "Bus Name",
                value: admin.busname,
                icon: Icons.directions_bus,
                onEdit: () => showEditDialog(
                  "Enter Bus Name",
                  busnamecontroller,
                  'busname',
                ),
              ),

              _buildInfoTile(
                label: "Registration No.",
                value: admin.regno,
                icon: Icons.confirmation_number_outlined,
                onEdit: () => showEditDialog(
                  "Enter Reg Name",
                  busregnocontroller,
                  'regno',
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: _buildInfoTile(
                        label: "Bus Type",
                        value: admin.type,
                        icon: Icons.category_outlined,
                        onEdit: () => _showBusTypeEditDialog(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: _buildInfoTile(
                        label: "Seat Capacity",
                        value: "${admin.seatno} Seats",
                        icon: Icons.event_seat_outlined,
                        isEditable: false,
                      ),
                    ),
                  ),
                ],
              ),

              _buildSectionHeader("Route Details"),

              // UP ROUTE
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF), // Light Blue
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          size: 16,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "UP Route",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoTile(
                      label: "From Depot",
                      value: admin.updepot.split(',').first,
                      icon: Icons.location_on_outlined,
                      onEdit: () => showEditDialog(
                        "Up Depot",
                        busupdepotcontroller,
                        'updepot',
                      ),
                    ),
                    _buildInfoTile(
                      label: "Departure",
                      value: admin.uptime,
                      icon: Icons.access_time,
                      onEdit: () => _showTimeEditDialog('uptime'),
                    ),
                  ],
                ),
              ),

              // DOWN ROUTE
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E6), // Light Orange
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          size: 16,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "DOWN Route",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoTile(
                      label: "From Depot",
                      value: admin.downdepot.split(',').first,
                      icon: Icons.location_on_outlined,
                      onEdit: () => showEditDialog(
                        "Down Depot",
                        downdepotcontroller,
                        'downdepot',
                      ),
                    ),
                    _buildInfoTile(
                      label: "Departure",
                      value: admin.downtime,
                      icon: Icons.access_time,
                      onEdit: () => _showTimeEditDialog('downtime'),
                    ),
                  ],
                ),
              ),

              _buildInfoTile(
                label: "Total Travel Time",
                value: admin.uptvtime,
                icon: Icons.timer_outlined,
                onEdit: () => _showTravelTimeEditDialog('uptvtime'),
              ),

              _buildSectionHeader("Pricing"),
              _buildInfoTile(
                label: "Ticket Price",
                value: "₹ ${admin.ticketprice}",
                icon: Icons.currency_rupee,
                onEdit: () => showEditDialog(
                  "Enter Amount",
                  ticketpricecontroller,
                  'ticketprice',
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(
        source: imageType,
        imageQuality: 50,
      );
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
        "POST",
        Uri.parse("${MyUrl.fullurl}bus_pic.php"),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'busimage',
          busphoto.readAsBytesSync(),
          filename: busphoto.path.split("/").last,
        ),
      );
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
      Fluttertoast.showToast(gravity: ToastGravity.CENTER, msg: e.toString());
    }
  }
}
