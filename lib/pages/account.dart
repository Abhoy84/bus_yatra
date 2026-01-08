import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticketbooking/models/usermodel.dart';
import 'package:ticketbooking/pages/color.dart';
import 'package:ticketbooking/pages/homepage.dart';
import 'package:ticketbooking/pages/loadingdialoge.dart';
import 'package:ticketbooking/pages/login.dart';

// ignore: must_be_immutable
class Account extends StatefulWidget {
  User user;
  Account(this.user, {super.key});

  @override
  State<Account> createState() => _AccountState(user);
}

class _AccountState extends State<Account> {
  User user;
  _AccountState(this.user);

  late SharedPreferences sp;

  bool nametype = false;
  bool emailtype = false;
  bool phonetype = false;
  bool passtype = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  void initState() {
    super.initState();
    passwordcontroller.text = "********";
    emailcontroller.text = user.email;
    namecontroller.text = user.fname;
    phonecontroller.text = user.phone;
  }

  Future<void> detailsupdate(
    String temail,
    String firstname,
    String phone,
    String email,
    String userid,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      await FirebaseFirestore.instance.collection('users').doc(userid).update({
        'fname': firstname,
        'phone': phone,
        'email': email,
      });

      sp = await SharedPreferences.getInstance();
      user.fname = firstname;
      user.phone = phone;
      user.email = email; // Update local user object as well

      sp.setString('fname', firstname);
      sp.setString('phone', phone);
      sp.setString('email', email);

      if (mounted) {
        setState(() {});
        Navigator.pop(context); // Close loading dialog
      }

      if (temail != email) {
        // Email changed, require relogin
        sp.remove('loginkey');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      } else {
        Fluttertoast.showToast(msg: "Profile Updated Successfully");
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog on error
      Fluttertoast.showToast(msg: "Update Failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dark Theme Colors
    final Color backgroundColor = C.theamecolor;
    final Color surfaceColor = Colors.white.withOpacity(0.08);
    const Color primaryText = Colors.white;
    final Color secondaryText = Colors.white.withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (builder) => homepage(user)),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Manage your personal information",
                style: TextStyle(
                  fontSize: 16,
                  color: secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Personal Details", secondaryText),
                        const SizedBox(height: 15),
                        _buildMinimalField(
                          label: "Full Name",
                          controller: namecontroller,
                          isEnabled: nametype,
                          surfaceColor: surfaceColor,
                          textColor: primaryText,
                          labelColor: secondaryText,
                          onEdit: () => setState(() => nametype = !nametype),
                        ),
                        const SizedBox(height: 15),
                        _buildMinimalField(
                          label: "Phone Number",
                          controller: phonecontroller,
                          isEnabled: phonetype,
                          keyboardType: TextInputType.phone,
                          surfaceColor: surfaceColor,
                          textColor: primaryText,
                          labelColor: secondaryText,
                          onEdit: () => setState(() => phonetype = !phonetype),
                        ),

                        const SizedBox(height: 30),
                        _buildSectionHeader("Account Security", secondaryText),
                        const SizedBox(height: 15),
                        _buildMinimalField(
                          label: "Email Address",
                          controller: emailcontroller,
                          isEnabled: emailtype,
                          surfaceColor: surfaceColor,
                          textColor: primaryText,
                          labelColor: secondaryText,
                          onEdit: () => _showEmailWarning(),
                          validator: (value) {
                            if (value!.isEmpty) return 'Cannot be empty';
                            if (!value.contains('@')) return 'Invalid Email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildMinimalField(
                          label: "Password",
                          controller: passwordcontroller,
                          isEnabled: false,
                          obscureText: true,
                          surfaceColor: surfaceColor,
                          textColor: primaryText,
                          labelColor: secondaryText,
                          onEdit: () {
                            Fluttertoast.showToast(
                              msg: "Please contact support to reset password",
                            );
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        detailsupdate(
                          user.email, // Passing original email as 'temail' to check for changes
                          namecontroller.text,
                          phonecontroller.text,
                          emailcontroller.text,
                          user.uid,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Contrast text for button
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildMinimalField({
    required String label,
    required TextEditingController controller,
    required bool isEnabled,
    required VoidCallback onEdit,
    required Color surfaceColor,
    required Color textColor,
    required Color labelColor,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor, // Translucent dark
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ), // Subtle border
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: isEnabled,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEnabled ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEnabled ? Icons.check : Icons.edit_outlined,
                color: isEnabled ? Colors.black : labelColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmailWarning() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C), // Dark dialog bg
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Change Email?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Updating your email address will require you to log in again with the new credential.',
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => emailtype = false);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => emailtype = true);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
